
# ALARM

<!-- badges: start -->
<!-- badges: end -->

The `{ALARM}` package provides a single primary function,
`predictALARM()` to predict the absolute risk of lung cancer mortality
based on a set of covariates and a chosen time horizon.

The models used to make predictions are based on the following study
([link](https://www.medrxiv.org/content/10.1101/2022.04.22.22274185v1)):

> Warkentin MT, Tammemägi MC, Espin-Garcia O, Budhathoki S, Liu G, Hung
> RJ. Asian Lung Cancer Absolute Risk Models for lung cancer mortality
> based on China Kadoorie Biobank. medRxiv. 2022 Apr 23.

## Installation

You can install the development version of `ALARM` from GitHub using:

``` r
remotes::install_github('mattwarkentin/ALARM')
```

## Usage

You can make predictions for the absolute risk of lung cancer mortality
by supplying a `data.frame` with the requisite covariates and a time
horizon. See `?validate_data` for more details on the expected format of
the data.

``` r
library(ALARM)

data <- data.frame(age = 70, sex = 1, fhx_cancer = 1,
                   phx_cancer = 0, fev1fvc = 70, phx_lungdx = 1,
                   hhinc = 3, bmi = 30, 
                   smk_status = c(1, 2), smk_duration = c(NA, 30), 
                   smk_cigpday = c(NA, 25), smk_years_stop = c(NA, 0))

predictALARM(data, time = 5)
#>      age sex fhx_cancer phx_cancer fev1fvc phx_lungdx hhinc bmi smk_status
#>      smk_duration smk_cigpday smk_years_stop ALARM_pred
#>  [ reached 'max' / getOption("max.print") -- omitted 2 rows ]
```

`predictALARM()` returns a `data.frame` with the input data and an
additional column `ALARM_pred`, which contains the absolute risk
estimate.

## Code of Conduct

Please note that the ALARM project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
