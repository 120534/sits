% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sits_tibble_functions.R
\name{sits_sample}
\alias{sits_sample}
\title{Sample a percentage of a time series}
\usage{
sits_sample(data.tb, n = NULL, frac = NULL)
}
\arguments{
\item{data.tb}{Input sits tibble.}

\item{n}{Number of samples to pick from each group of data.}

\item{frac}{Percentage of samples to pick from each group of data.}
}
\value{
A sits tibble with a fixed quantity of samples of informed labels and all other.
}
\description{
Takes a sits tibble with different labels and
             returns a new tibble. For a given field as a group criterion, this new tibble contains a given number or percentage
             of the total number of samples per group. Parameter n indicantes the number of random samples with reposition.
             Parameter frac indicates a fraction of random samples without reposition. If frac > 1, no sampling is done.
}
\examples{
# Retrieve a set of time series with 2 classes
data(cerrado_2classes)
# Print the labels of the resulting tibble
sits_labels(cerrado_2classes)
# Samples the data set
data.tb <- sits_sample(cerrado_2classes, n = 10)
# Print the labels of the resulting tibble
sits_labels(data.tb)
}
\author{
Rolf Simoes, \email{rolf.simoes@inpe.br}
}
