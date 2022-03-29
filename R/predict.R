#' ALARM Predictions
#'
#' Makes predictions for the absolute risk of lung cancer mortality for
#'   never and ever smokers, based on a set of covariates, at a chosen time
#'   horizon.
#'   
#' @param data Data frame containing covariate values at which to produce
#'   absolute risk predictions. See `validate_data()` for information on the
#'   expected format of the `data`.
#' @param time Time horizon at which to make predictions.
#' @param ... Not currently used.
#'
#' @return A `tibble` with same number of rows as `newdata` and in the same 
#'   order. The `tibble` will contain the original columns plus the added
#'   column `ALARM`, which is the predicted absolute risk at time `time`.
#'
#' @examples 
#' 
#' data <- data.frame(age = 70, sex = 1, fhx_cancer = 1,
#'                    phx_cancer = 0, fev1fvc = 70, phx_lungdx = 1,
#'                    hhinc = 3, bmi = 30, smk_ever = c(0, 1),
#'                    smk_former = 1, smk_duration = 3, smk_cigpday = 15,
#'                    smk_years_stop = 0)
#' predictALARM(data)
#'
#' @export
predictALARM <- function(data, time = 5, ...) {
  rlang::is_scalar_integerish(time)
  validate_data(data)
  data <- 
    data %>% 
    dplyr::rename(
      age_entry = age,
      female = sex
    ) %>%
    dplyr::mutate(
      smk_former = factor(smk_former),
      fev1fvc_p5 = fev1fvc / 5,
      smk_duration_p5 = smk_duration / 5,
      smk_cigpday_p10 = smk_cigpday / 10,
      smk_years_stop_p5 = smk_years_stop / 5
    )
  
  data %>%
    dplyr::mutate(.id = 1:dplyr::n()) %>% 
    dplyr::group_by(smk_ever) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(
      ALARM = purrr::map2(
        smk_ever, data,
        ~ dplyr::if_else(.x == 1, predictES(.y, time), predictNS(.y, time))
      )
    ) %>% 
    dplyr::ungroup() %>% 
    tidyr::unnest(c(data, ALARM)) %>% 
    dplyr::arrange(.id) %>% 
    dplyr::select(-.id)
}

predictNS <- function(data, time, ...) {
  if (!exists('.ALARM_NS')) .ALARM_NS <- ALARM_NS()
  pr <- stats::predict(.ALARM_NS, newdata = data, times = time,
                       type = 'survival')
  risk <- 1 - pr$.pred_survival
  risk
}

predictES <- function(data, time, ...) {
  if (!exists('.ALARM_ES')) .ALARM_ES <- ALARM_ES()
  pr <- stats::predict(.ALARM_ES, newdata = data, times = time,
                       type = 'survival')
  risk <- 1 - pr$.pred_survival
  risk
}

utils::globalVariables(
  c('age', 'sex', 'smk_former', 'fev1fvc',
    'smk_duration', 'smk_cigpday', 'smk_years_stop',
    'smk_ever', 'ALARM', '.id',
    'predictNS', 'predictES')
)
