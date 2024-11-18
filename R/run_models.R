model_predict <- function(model,df,type='prob'){
    ### Hidden function to expedite prediction of functional use from
    ### randomForest model objects
    ### Parameters
    ### ----------
    ### model: randomForest model object
    ### df: DataFrame of ToxPrints features for N chemicals
    ### type: passed to predict.randomForest as the type of prediction to return
    ###
    ### Returns
    ### a N chemical length vector containing predictions for the passed model
    if (type=="prob"){
        x <- as.vector(randomForest:::predict.randomForest(model,df,
                                                           type=type)[,2])
    } else {
        x <- as.vector(randomForest:::predict.randomForest(model,df))
    }
    return(x)
}



#' Predict with a Single QSUR Model
#'
#' Provides predictions of a single harmonized use QSUR model from a passed data
#' frame of N chemicals with all 730 ToxPrints
#' @param model randomForest model object
#' @param df ToxPrint DataFrame of chemicals to predict
#' @param type type of prediction to get from RF model (prob, response, or vote)
#' @param chemical_id name of chemical_id used, default is `chemical_id`
#' @export
#' @examples
#' predict_one_QSUR()
predict_one_QSUR <- function(model,df,type='prob',chemical_id='chemical_id'){
    preds <- tibble::tibble({{chemical_id}}:=df[[chemical_id]])
    preds[['probability']] <- model_predict(model=model,df=df,type=type)
    return (preds)
}



#' Predict with all 39 QSUR Models
#'
#' Provides predictions of all 39 valid harmonized use QSUR model from a passed
#' data frame of N chemicals with all 730 ToxPrints
#' @param model randomForest model object
#' @param df ToxPrint DataFrame of chemicals to predict
#' @param type type of prediction to get from RF model (prob, response, or vote)
#' @param chemical_id name of chemical_id used, default is `chemical_id`
#' @export
#' @examples
#' predict_all_QSUR()
predict_all_QSUR <- function(models,df,type='prob',chemical_id='chemical_id'){
    `%>%` <- dplyr::`%>%`
    preds <- lapply(models, QSUR:::model_predict, df=df, type=type)
    preds <- as.data.frame(do.call(cbind,preds))
    preds <- preds %>% tibble::add_column({{chemical_id}}:=df[[chemical_id]],
                                          .before=names(models)[1])

    preds <- preds %>% dplyr::mutate(dplyr::across({{chemical_id}},
                                                   as.character))
    return(tibble::tibble(preds))
}



#' Predict if a record is in a model's domain of applicability
#'
#' For each record in a testing set of data, applicability_domain
#' determines if that record lies within the domain of applicability of the
#' training set for a given class in a classification model. See the following
#' for more information on these methods:
#' Rational selection of training and test sets for the development
#'   of valid QSAR models, A. Golbraikh, et al., J. Comp.-Aided Mol. Design,
#'   17 (2003), 241 -- 253.
#' Predictive QSAR modeling workflow, model applicability domains,
#'   and virtual screening, A. Tropsha and A. Golbraikh, Curr. Pharm. Design,
#'   13 (2007), 3494 -- 3504.
#'
#' @param models list of models, or "classes", for which to determine domain
#' @param df ToxPrint DataFrame of chemicals to predict
#' @param sim_cut NULL or float. If NULL, use stored values calculated for a
#' similarity threshold of 0.5, if float fraction from 0 to 1 for how similar
#' records should be, default=NULL
#' @param method distance metric to use for similarity calculation
#' @export

in_domain <- function(models,df,chemical_id='chemical_id',method="jaccard"){

    ## The names data.frame assigned to ToxPrints when I first build the models
    toxps <- tail(colnames(as.data.frame(df)),n=-1)

    ## Get the original training set
    training <- QSUR:::fuse
    training <- training %>% mutate(harmonized_use = forcats::fct_recode(harmonized_use,"rubber_additive" = "additive_for_rubber"))
    training <- training %>% mutate(harmonized_use = forcats::fct_recode(harmonized_use, "rheology_modifier" = "rheology_modifer"))
    ## The distance/similarity cutoffs for each harmonized_use
    d_cuts <- QSUR:::d_cuts

    ## Initialize tibble to store domain app info
    domain <- tibble::tibble({{chemical_id}}:=df[[chemical_id]])

    ## Just keep the toxps for the distance calculation
    df <- df[,toxps]
   ## Loop over all models
    for (model in names(models)){

        ## Get the training set for a specific model, and only keep its
        ## descriptors.
        rows <- which(training[['harmonized_use']]==model)
        train <- training[rows,toxps]


        ## Throw message and skip if there are not enough records for the class
        ## in the training set.
        if (dim(train)[1] == 0){
            paste(c("not enough training for ",model),sep="",collapse="")
            next
        }

        ## Throw message and skip if there are not enough records for the class
        ## in the predicted set.
        if (dim(df)[1] == 0){
            paste(c("not enough testing for ",model),sep="",collapse="")
            next
        }

        ## This is the similarity threshold that Tropsha uses in most of his
        ## QSAR validation work: d_cut <- Z*d_avg + d_std
        d_cut <- d_cuts[[model]]

        ## Caluculate the pair-wise distances between molecules in the training
        ## set and predictions
        d_train_preds <- proxy::dist(train,df,method=method)

        ## Now that you know the distances see if they meet the threshold
        ## requirement. Find the closed training chemical to the predicted
        ## chemicals, and store that distance
        d_ij <- apply(d_train_preds,2,"min")

        ## Now for each predicted chemical, see if that closest distance is less
        ## than the threshold distance
        is_in <- sapply(d_ij,function(x){x < d_cut})

        ## Save each functions domain calls as a column in the tibble
        domain[[model]] <- as.vector(is_in)
   }
    ## Return data frame indices of records within domain of applicability

    return(domain)
}
