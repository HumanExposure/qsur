# QSUR
R package for 2017 Quantitative-Structure User Relationship model predictions

## Disclaimer
The United States Environmental Protection Agency through its Office of Research and Development funded and collaborated in the research and development of this software, in part under Contract EP-C-14-001 to ICF International. The model is publicly available in Beta version form. All input data used for a given application should be reviewed by the researcher so that the model results are based on appropriate data sources for the given application. This model, default input files, and R package are under continued development and testing. The model equations and approach are published in the peer-reviewed literature [Phillips et al., *Green Chem.*. 2017, **19**, 1063-1074](https://doi.org/10.1039/C6GC02744J)). The data included herein do not represent and should not be construed to represent any Agency determination or policy.

## Requirements
- `randomForest`
- `tidyverse`
- `proxy`
## Installation
Using the `devtools` package in R is the most straightforward way to download and install this package:
```{R}
devtools::intsall_github("repository/link")
```
As a note: installation will take at lease 10 minutes (give or take) depending on the computer you are attempting to install this package on. The model files are quite large and thus will require time to download and install.


## Usage

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
