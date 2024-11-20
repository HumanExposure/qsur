# QSUR
R package for 2017 Quantitative-Structure User Relationship model predictions

## Disclaimer
The United States Environmental Protection Agency, through its Office of Research and Development's Chemical Safety for Sustainability research program, provided funding and managed the research described here. This research was supported in part by an appointment to the Postdoctoral Research Program at the National Exposure Research Laboratory, administered by the Oak Ridge Institute for Science and Education through Interagency Agreement No. DW-89-92298301-0 between the U.S. Department of Energy and the U.S. Environmental Protection Agency. The model methods and their training data are published in the peer-reviewed literature ([Phillips et al., *Green Chem.*. 2017, **19**, 1063-1074](https://doi.org/10.1039/C6GC02744J)). The dissemination of these models and their training data in R package form is under continued development and testing. The data included herein do not represent and should not be construed to represent any Agency determination or policy. Mention of software or other commercial products does not imply endorsement by the Agency.

## Requirements
- `randomForest`
- `tidyverse`
- `proxy`
## Installation
Using the `devtools` package in R is the most straightforward way to download and install this package:
```{R}
devtools::install_github("https://github.com/HumanExposure/qsur.git")
```
If you are using the `renv` package to utilize self-contained coding environments, use can use the `renv::install` command to install this package instead.
```{R}
renv::install("HumanExposure/qsur")
```
As a note: installation will take at lease 10 minutes (give or take) depending on the computer you are attempting to install this package on. The model files are quite large and thus will require time to download and install.


## Usage
### Using a batch download of ToxPrint's from U.S. EPA's [CompTox Chemicals Dashboard](https://comptox.epa.gov/dashboard)

CCD's batch download has the following format:

|INPUT|FOUND_BY|DTXSID|PREFERRED_NAME|atom:element_main_group|...|
|-----|--------|------|--------------|-----------------------|---|
|100-41-4|CASRN|DTXSID3020596|  Ethylbenzene|0|...|
|100-42-5|CASRN|DTXSID2021284|       Styrene|0|...|
|100-51-6|CASRN|DTXSID5020152|Benzyl alcohol|0|...|
|100-52-7|CASRN|DTXSID8039241|  Benzaldehyde|0|...|
|101-20-2|CASRN|DTXSID4026214|  Triclocarban|0|...|

```{R}
## Path to file created obtained via download from US EPA's CompTox Chemcials
## Dashboard (CCD).
path <- "tests/toxprints_ccd_test.csv"

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
valids <- QSUR::in_domain(models = qsurs,
                          df = chems,
                          chemical_id = "dtxsid")
```

### Using a file from Altamira's [ChemoTyper application](https://github.com/mn-am/chemotyper)

ChemoTyper's output file has the following format:
|dtxsid|atom:element_main_group|...|
|------|-----------------------|---|
|DTXSID001021219|0|...|
|DTXSID00865378|0|...|
|DTXSID10196165|0|...|
|DTXSID1020697|0|...|
|DTXSID1026796|0|...|

Note: usually to get a working file from ChemoTyper, you must have a `.smi` file similar to that in `tests/test.smi`, then ChemoTyper will convert this to a file with the above format. If you wish to skip this step, you can now use the option to retrieve the ToxPrints with the `calculate_toxprints` function (see **Using a File of SMILES below**).

```{R}
## Path to file created from the ChemoTyper application.
path <- "tests/toxprints_chemotyper_test.csv"

## Read the ToxPrint file from ChemoTyper
chems <- QSUR::read_toxprints(io=path,
                              source='chemotyper')

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
valids <- QSUR::in_domain(models = qsurs,
                          df = chems,
                          chemical_id = "dtxsid")
```

### Using a single SMILES

In this case only a single chemical's predictions are needed, so only the structure of the chemical (in SMILES format) needs to be provided.

```{R}
smiles <- "ClC1=CC=C(NC(=O)NC2=CC=C(Cl)C(Cl)=C2)C=C1"
toxp <- QSUR::calculate_toxprints(smiles)
qsurs <- QSUR::qsur_models()
uses <- QSUR::predict_all_QSUR(models=qsurs, df=toxp)
valids <- QSUR::in_domain(models=qsurs, df=toxp)
```

### Using a file of SMILES

This file has the following format (see `tests/test.smi`):

```{text}
CCCCNC(=O)OCC#CI
O([As]1C2=C(OC3=C1C=CC=C3)C=CC=C2)[As]1C2=C(OC3=C1C=CC=C3)C=CC=C2
CCCCCCCCN1SC=CC1=O
[Cu]
CN1SC=CC1=O
CCCCN1SC2=C(C=CC=C2)C1=O
[Ag]
[Cl-].ClC=CC[N+]12CN3CN(CN(C3)C1)C2
```

Predictions for this file can be obtained with the following code.

```{R}
chems <- vroom::vroom("tests/test.smi", delim='\t', col_names="SMILES")
toxp <- QSUR::calculate_toxprints(chems$SMILES)
qsur <- QSUR::qsur_models()
preds <- QSUR::predict_all_QSUR(models=qsurs, df=toxp)
valids <- QSURS::in_domain(models=qsurs, df=toxp)
```

### Misc.
Best practices dictate using only chemicals that are in a model's domain of applicability. Rather than first getting the predictions for all submitted chemicals and then determininging the domain of applicability, users can now supply a data frame of ToxPrints and return only predictions that are in domain for a model with the `predict_all_in_domain` function.
```{R}
chems <- vroom::vroom("tests/test.smi", delim='\t', col_names="SMILES")
toxp <- QSUR::calculate_toxprints(chems$SMILES)
qsur <- QSUR::qsur_models()
valids <- QSUR::predict_all_in_domain(models=qsurs, df=toxp)
```