# QSUR
R package for 2017 Quantitative-Structure User Relationship model predictions

## Disclaimer
The United States Environmental Protection Agency, through its Office of Research and Development's Chemical Safety for Sustainability research program, provided funding and managed the research described here. This research was supported in part by an appointment to the Postdoctoral Research Program at the National Exposure Research Laboratory, administered by the Oak Ridge Institute for Science and Education through Interagency Agreement No. DW-89-92298301-0 between the U.S. Department of Energy and the U.S. Environmental Protection Agency. The model methods and their training data are published in the peer-reviewed literature ([Phillips et al., *Green Chem.*. 2017, **19**, 1063-1074](https://doi.org/10.1039/C6GC02744J)). The dissemination of these models and their training data in R package form is under continued development and testing. The data included herein do not represent and should not be construed to represent any Agency determination or policy.

## Requirements
- `randomForest`
- `tidyverse`
- `proxy`
## Installation
Using the `devtools` package in R is the most straightforward way to download and install this package:
```{R}
devtools::intsall_github("https://github.com/HumanExposure/qsur.git")
```
As a note: installation will take at lease 10 minutes (give or take) depending on the computer you are attempting to install this package on. The model files are quite large and thus will require time to download and install.


## Usage
```{R}
## Path to file created obtained via download from US EPA's CompTox Chemials
## Dashboard (CCD).
path <- "ccd_test_chems.tsv"

## Read the ToxPrint file. Change source to `chemotyper` if you have a
## ToxPrints file created from the ChemoTyper application. Supply the type
## of chemical id you'd like to use from the file.
chems <- QSUR::read_toxprints(io=path,
                              source='ccd',
                              chemical_id='dtxsid')

## Load all the QSUR models in the package
qsurs <- QSUR::qsur_models()

## Predict with just a single QSUR model.
adds <- QSUR::predict_one_QSUR(model=qsurs$additive,
                               df=chems,
                               chemical_id='dtxsid')

## Predict with all the QSUR models in the package
preds <- QSUR::predict_all_QSUR(models=qsurs,
                                df=chems,
                                chemical_id='dtxsid')

## Get all of the predictions that are within the domain of applicability of
## a given model
valids <- QSUR::in_domain(models=chems,
                          df=chems,
                          chemcial_id='dtxsid')
```
