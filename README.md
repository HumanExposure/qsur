# QSUR
R package for 2017 Quantitative-Structure User Relationship model predictions

## Requirements
- `randomForest`
- `tidyverse`
- `proxy`
## Installation
You *should* be able to install this package with the `install_github` function in the R package `devtools`. But you will need a personal access token from GitHub: got to user profile in top right corner -> gear/settings, then on left list of settings click Developer Settings, the click personal acces tokens, then Tokens (classic), check repo box, then generate. Copy access token and store it in .gitconfig

Then go to R:
```{R}
devtools::install_github("kaphillips/QSUR",auth_token="personal access token generated by GitHub",INSTALL_opts="--no-staged-install")
```
## Release Notes:
alpha release and because I didn't have access to linux box, there are only 4 QSUR models in the package and only 100 records in the training set (adding such large files to sysdata.rda takes a long time and most of the memory on my laptop). I will add the remaining soon.

## To Do:
- Add remaining QSUR models to sysdata.rda
- Add full training set to sysdata.rda
- Add option to dump results to files; output options will be
    - `sheets`: all predictions on one Worksheet and all domain of applicability statuses on another worksheet
    - `masked`: a masked DataFrame where get the $n_{chems} \times n_{uses}$ data frame, but you only see probabilty values for predictions that were in the domain of applicability
    - `melted`: (default) takes the `masked` array and melts it such that you get a DataFrame with three fields: `chemical_id`, `harmonized_use`, and `probabilty` and each row indicates one prediction that was in the domain of applicability for the specified model.
- Add `workflow` function that will just take a ToxPrint file name and spit out the results, and provide the user the abliity to filter on domain of applicability and acceptable probabilty for prediction (default 80%).
## Usage
For now the usage should be as follows:
```{R}
## Path to file created by ChemoTyper application.
path <- "chemotyper_test_chems.tsv"

## Read the ToxPrint file. Change source to `ccd` if you have a ToxPrints file
## downloaded from CompTox Chemicals Dashboard (CCD).
chems <- QSUR::read_toxprints(io=path,source='chemotyper')

## Load all the QSUR models in the package
qsurs <- QSUR::qsur_models()

## Predict with just a single QSUR model.
adds <- QSUR::predict_one_QSUR(qsurs$additive,chems)

## Predict with all the QSUR models in the package
preds <- QSUR::predict_all_QSUR(qsurs,chems)

valids <- QSUR::in_domain(preds=chems,models=qsurs)
```