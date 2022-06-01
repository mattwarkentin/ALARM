#' Validate Data for ALARM
#' 
#' `validate_data` is used to ensure all of the predictors are in the expected
#'   format before making predictions. This function is called internally by
#'   [`predictALARM()`].
#' 
#' @param data A `data.frame` with the following numeric columns, in any order:
#'   * `age` - Age (years)
#'   * `sex` - Sex (0 = Man, 1 = Woman)
#'   * `fhx_cancer` - Family history of any cancer? (0 = No, 1 = Yes)
#'   * `phx_cancer` - Personal history of cancer? (0 = No, 1 = Yes)
#'   * `fev1fvc` - FEV1 / FVC (between 0 and 1)
#'   * `phx_lungdx` - Personal history of COPD? (0 = No, 1 = Yes)
#'   * `hhinc` - Household income (see `Details`)
#'   * `bmi` - Body Mass Index (kg/m^2)
#'   * `smk_status` - Smoking status (1 = Never, 1 = Former, 3 = Current)
#'   * `smk_duration` - Smoking duration (years)
#'   * `smk_cigpday` - Smoking intensity (no. cigarettes per day)
#'   * `smk_years_stop` - Years since quitting (years)
#'
#' @details Household income has 6 levels. The levels are defined in yuan, and
#'   the approximate USD equivalents are present in parentheses. Household
#'   income levels: `0 = < 2500` (< 384), `1 = 2500-4999` (384-767),
#'   `2 = 5000-9999` (767-1537), `3 = 10000-19999` (1537-3075),
#'   `4 = 20000-34999` (3075-5381), and `5 = >= 35000` (>= 5381).
#'   
#' @return `FALSE` if the data set is invalid, otherwise nothing.
#' 
#' @export
validate_data <- function(data) {
  check_range(data$age, 40, 80, 'age')
  check_levels(data$sex, c(0L, 1L), 'sex')
  check_levels(data$fhx_cancer, c(0L, 1L), 'fhx_cancer')
  check_levels(data$phx_cancer, c(0L, 1L), 'phx_cancer')
  check_range(data$fev1fvc, 0, 100, 'fev1fvc')
  check_levels(data$phx_lungdx, c(0L, 1L), 'phx_lungdx')
  check_levels(data$hhinc, c(0L, 1L, 2L, 3L, 4L, 5L), 'hhinc')
  check_range(data$bmi, 18, 50, 'bmi')
  check_levels(data$smk_status, c(1L, 2L, 3L), 'smk_status')
  check_range(data$smk_duration, 0, Inf, 'smk_duration')
  check_range(data$smk_cigpday, 0, Inf, 'smk_cigpday')
  check_range(data$smk_years_stop, 0, Inf, 'smk_years_stop')
}

check_levels <- function(x, levels, nm) {
  error_msg <- paste0(
    '`', nm, '`',
    ' must be a numeric vector with levels [',
    paste(levels, collapse = ','), '].'
  )
  x <- stats::na.omit(x)
  if (!is.numeric(x)) rlang::abort(error_msg)
  if (!all(x %in% levels)) rlang::abort(error_msg)
  invisible()
}

check_range <- function(x, low, high, nm) {
  error_msg <- paste0(
    '`', nm, '`',
    ' must be a numeric vector in the range ',
    '[', low, ',', high, '].'
  )
  x <- stats::na.omit(x)
  if (!all(x >= low & x <= high)) rlang::abort(error_msg)
  invisible()
}
