% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sits_config.R
\name{.sits_get_resolution}
\alias{.sits_get_resolution}
\title{Retrieve the pixel resolution for an image product}
\usage{
.sits_get_resolution(service, name)
}
\arguments{
\item{service}{The name of the service}

\item{name}{the name of the coverage}
}
\value{
res           vector of (xres, yres)
}
\description{
Retrieve the pixel resolution for an image product
}
\author{
Gilberto Camara, \email{gilberto.camara@inpe.br}
}