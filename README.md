
# ALARM: Asian Lung Cancer Absolute Risk Models

<!-- badges: start -->
<!-- badges: end -->

The `{ALARM}` package provides a single primary function,
`predictALARM()` to predict the absolute risk of lung cancer mortality
based on a set of covariates and a chosen time horizon.

The models used to make predictions are based on the following study
([link](https://doi.org/10.1093/jnci/djac176)):

> Warkentin MT, Tammemägi MC, Espin-Garcia O, Budhathoki S, Liu G, Hung RJ. Lung Cancer absolute risk models for mortality in an Asian population using the China Kadoorie Biobank. JNCI: Journal of the National Cancer Institute. 2022 Dec 1;114(12):1665-73.

## Installation

You can install `ALARM` from GitHub using:

``` r
remotes::install_github('mattwarkentin/ALARM')
```

## Usage

Once the package has been installed, we can load the package and make
predictions for the absolute risk of lung cancer mortality by supplying
a `data.frame` with the requisite covariates and a time horizon to
`predictALARM()`.

In this example, we will create some example data for two individuals,
one ever-smoker and one never-smoker, with similar covariate values,
with the exception of smoking history which are set to missing (`NA`)
for the never-smoker. Please see `?validate_data` for more details on
the expected format of the input data.

``` r
library(ALARM)

data <- data.frame(age = 70, sex = 1, fhx_cancer = 1,
                   phx_cancer = 0, fev1fvc = 70, phx_lungdx = 1,
                   hhinc = 3, bmi = 30, 
                   smk_status = c(1, 2), smk_duration = c(NA, 40), 
                   smk_cigpday = c(NA, 20))
```

Next, we use the `predictALARM()` function to estimate the absolute risk
of lung cancer mortality for a given time horizon, *t* (e.g.,
`time = 5`).

``` r
predictALARM(data, time = 5)
#>   age sex fhx_cancer phx_cancer fev1fvc phx_lungdx hhinc bmi smk_status
#> 1  70   1          1          0      70          1     3  30          1
#> 2  70   1          1          0      70          1     3  30          2
#>   smk_duration smk_cigpday  ALARM_pred
#> 1           NA          NA 0.004494043
#> 2           40          20 0.020674301
```

`predictALARM()` returns a `data.frame` that contains all of the columns
from the input `data`, with the addition of a new column, `ALARM_pred`,
which contains the lung cancer mortality absolute risk estimates at the
chosen time horizon and conditional on the subjects’ covariates.

## Code of Conduct

Please note that the ALARM project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
