#' QSUR.
#' QSUR: A package storing 39 structure based QSUR models.
#'
#' The QSUR package contains all 39 validated quantitative structure-use
#' relationship models that were developed in Phillips et al 2017
#' (https://doi.org/10.1039/C6GC02744J). It contains three differnt data
#' objects: qsur_model_list, qsur_model_training_set, and toxprint_names.
#'
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
