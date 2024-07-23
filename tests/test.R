## Read a test file from the CCD Batch Download
## This file was obtained with a list of DTXSID and the following steps
## 1. Go to: https://comptox.epa.gov/dashboard/batch-search
## 2. select “Substance Identifiers” 
## 3. enter your identifiers in the search box 
## 4. select “Choose Export Options”
## 5. select “Choose Export Type” as csv; under “Intrinsic and Predicted Properties” select “ToxPrint fingerprints (separate columns)”
## 6. select “Download Export File”
ccd_chems <- QSUR::read_toxprints(
    io = "toxprint_ccd_test.csv",
    source = "ccd",
    chemical_id = "dtxsid"
)

chemo_chems <- QSUR::read_toxprints(
    io = "toxprint_chemotyper_test.tsv",
    source = "chemotyper",
    chemical_id = "dtxsid"
)