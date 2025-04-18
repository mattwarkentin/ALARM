% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.R
\name{predictALARM}
\alias{predictALARM}
\title{ALARM Predictions}
\usage{
predictALARM(data, time = 5, ...)
}
\arguments{
\item{data}{Data frame containing covariate values at which to produce
absolute risk predictions. See \code{\link[=validate_data]{validate_data()}} for information on the
expected format of the \code{data}.}

\item{time}{Time horizon at which to make predictions.}

\item{...}{Not currently used.}
}
\value{
A \code{data.frame} with same number of rows as \code{newdata}, and in the
same order. The \code{data.frame} will contain the original columns plus the
added column \code{ALARM_pred}, which is the predicted absolute risk of lung
cancer mortality at time \code{time}.
}
\description{
Makes predictions for the absolute risk of lung cancer mortality for
never and ever smokers, based on a set of covariates, at a chosen time
horizon.
}
\examples{

data <- data.frame(age = 70, sex = 1, fhx_cancer = 1,
                   phx_cancer = 0, fev1fvc = 70, phx_lungdx = 1,
                   hhinc = 3, bmi = 30, 
                   smk_status = c(1, 2), smk_duration = c(NA, 40), 
                   smk_cigpday = c(NA, 20))
predictALARM(data)

}
\seealso{
\code{\link[=validate_data]{validate_data()}}
}
