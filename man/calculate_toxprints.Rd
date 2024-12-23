% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_data.R
\name{calculate_toxprints}
\alias{calculate_toxprints}
\title{Calculate ToxPrint features}
\usage{
calculate_toxprints(smiles, pause = 0.5)
}
\arguments{
\item{smiles}{character of single chemical structure or list of multiple chemical
structure representations of SMILES strings}

\item{pause}{delay between API calls to get ToxPrints from a SMILES string}
}
\description{
Supply either a single SMILES string or a list of SMILES strings and this function
will return a data.frame of ToxPrint features with the SMILES as the chemical_id
columns. This data.frame can then be used as input into the predict_all_QSUR or
predict_one_QSUR functions.
}
\examples{
calculate_toxprints()
}
