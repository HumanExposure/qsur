% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load_data.R
\name{read_toxprints}
\alias{read_toxprints}
\title{Read ToxPrints finger print file}
\usage{
read_toxprints(io, source, chemical_id = "chemical_id")
}
\arguments{
\item{io}{path and name of file to read}

\item{source}{either \code{chemotyper} or \code{ccd}}

\item{chemical_id}{name of chemical_id used, default is \code{chemical_id}}
}
\description{
Import ToxPrint file from the ChemoTyper (\code{source="chemotyper"}) application
or from a batch download originating from the EPA CompTox Chemicals Dashboard
(\code{source="ccd"}) and return a tibble of the chemical identifier
(\code{chemical_id}) and the 729 ToxPrints features.
}
\examples{
read_toxprintsl()
}
