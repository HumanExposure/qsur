#' Read ToxPrints finger print file
#'
#' Import ToxPrint file from the ChemoTyper (`source="chemotyper"`) application
#' or from a batch download originating from the EPA CompTox Chemicals Dashboard
#' (`source="ccd"`) and return a tibble of the chemical identifier
#' (`chemical_id`) and the 729 ToxPrints features.
#' @param io path and name of file to read
#' @param source either `chemotyper` or `ccd`
#' @param chemical_id name of chemical_id used, default is `chemical_id`
#' @export
#' @examples
#' read_toxprintsl()

read_toxprints <- function(io,source,chemical_id=NULL){

    if (source == "chemotyper") {
        ## ChemoTyper: tsv file, empty ToxPrints are all 0 values, chemical
        ## identifier colunm is only `M_NAME`
        df <- readr::read_tsv(io)

        if (is.null(chemical_id)){chemical_id="M_NAME"}
        # df <- dplyr::rename(df,{{chemical_id}}:="M_NAME")

    } else if (source == "ccd") {
        ## CCD: csv file, empty ToxPrints have N/A as first ToxPrint and are
        ## blank for the rest, multiple chemical identifier columns possible
        df <- readr::read_csv(io,na=c("","NA",'N/A'))

        tp <- QSUR:::toxprints
        idx <- which(!(colnames(df) %in% tp))

        ## Lower case the chemical id columns
        colnames(df)[idx] <- tolower(colnames(df)[idx])

        ## Throw and error if the chemical_id is not in the id columns
        if (!(chemical_id %in% colnames(df))){
            stop(paste0("Error! `",chemical_id,"` not in df column names."))
        }

        ## Keep only the desired ID column and the ToxPrint columns
        cols <- c(chemical_id,tp)
        df <- df[which(colnames(df) %in% cols)]

        ## Get rid of the problem childs -- that is the rows that have no
        ## ToxPrints
        problems <- as.integer(dim(df[is.na(df['atom:element_main_group']),])[1])
        df <- df[!is.na(df['atom:element_main_group']),]
    }

    ## The models were built using standard data.frames, but tibbles don't
    ## convert the column names, so force it because you'll need these names
    ## when predicting later
    colnames(df) <- colnames(data.frame(df))

    ## Now, there can be ToxPrints that are either NULL or that have all 0
    ## values for a substance. Warn the user that these are being removed.

    return(df)
}


#' Load QSUR Models
#'
#' Import a named list of all 39 valid, structure-only QSUR models contained
#' within this package. Names of the list are the harmonized use predicted by
#' that randomForest object value in the named list.
#' @param harmonized_use name of model to use
#' @export
#' @examples
#' qsur_models()
qsur_models <- function(){
    return(QSUR:::qsurs)
}
