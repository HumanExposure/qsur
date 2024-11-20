#' QSUR.
#' QSUR: A package storing 39 structure based QSUR models.
#'
#' Description: Encapsulates the quantitative structure-use relationship models developed 
#'     in *High-throughput screening of chemicals as functional substitutes using 
#'     structure-based classification models* (DOI: https://doi.org/10.1039/c6gc02744j)
#'     along with the capabilities to load new external chemicals for prediction and use 
#'     the models themeselves for predicting.
#'
"_PACKAGE"

#' @section qsur_models
#' qsur_model_list list is a named list with the harmonized functional use being
#' the name and the randomForest model object being the item. The following are
#' the names of the QSUR models contained in this list:
#' \itemize{
#'     \item{"additive"}
#'     \item{"adhesion_promoter"}
#'     \item{"antimicrobial"}
#'     \item{"antioxidant"}
#'     \item{"antistatic_agent"}
#'     \item{"buffer"}
#'     \item{"catalyst"}
#'     \item{"chelator"}
#'     \item{"colorant"}
#'     \item{"crosslinker"}
#'     \item{"emollient"}
#'     \item{"emulsifier"}
#'     \item{"emulsion_stabilizer"}
#'     \item{"flame_retardant"}
#'     \item{"flavorant"}
#'     \item{"foam_boosting_agent"}
#'     \item{"foamer"}
#'     \item{"fragrance"}
#'     \item{"hair_conditioner"}
#'     \item{"hair_dye"}
#'     \item{"heat_stabilizer"}
#'     \item{"humectant"}
#'     \item{"lubricating_agent"}
#'     \item{"monomer"}
#'     \item{"organic_pigment"}
#'     \item{"oxidizer"}
#'     \item{"photoinitiator"}
#'     \item{"preservative"}
#'     \item{"reducer"}
#'     \item{"rheology_modifier"}
#'     \item{"rubber_additive"}
#'     \item{"skin_conditioner"}
#'     \item{"skin_protectant"}
#'     \item{"soluble_dye"}
#'     \item{"surfactant"}
#'     \item{"uv_absorber"}
#'     \item{"vinyl"}
#'     \item{"wetting_agent"}
#'     \item{"whitener"}
#' }
