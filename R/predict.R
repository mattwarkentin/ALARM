#' ALARM Predictions
#'
#' Makes predictions for the absolute risk of lung cancer mortality for
#'   never and ever smokers, based on a set of covariates, at a chosen time
#'   horizon.
#'   
#' @param data Data frame containing covariate values at which to produce
#'   absolute risk predictions. See [`validate_data()`] for information on the
#'   expected format of the `data`.
#' @param time Time horizon at which to make predictions.
#' @param ... Not currently used.
#'
#' @return A `data.frame` with same number of rows as `newdata`, and in the
#'   same order. The `data.frame` will contain the original columns plus the
#'   added column `ALARM_pred`, which is the predicted absolute risk of lung
#'   cancer mortality at time `time`.
#'
#' @seealso [`validate_data()`]
#'
#' @md
#'
#' @examples
#' 
#' data <- data.frame(age = 70, sex = 1, fhx_cancer = 1,
#'                    phx_cancer = 0, fev1fvc = 70, phx_lungdx = 1,
#'                    hhinc = 3, bmi = 30, 
#'                    smk_status = c(1, 2), smk_duration = c(NA, 30), 
#'                    smk_cigpday = c(NA, 25), smk_years_stop = c(NA, 0))
#' predictALARM(data)
#'
#' @export
predictALARM <- function(data, time = 5, ...) {
  rlang::is_scalar_integerish(time)
  validate_data(data)
  data_orig <- data
  data_fmt <- 
    data %>% 
    dplyr::rename(
      age_entry = age,
      female = sex
    ) %>%
    dplyr::mutate(
      smk_status = dplyr::case_when(
        smk_status == 1L ~ 'never',
        smk_status == 2L ~ 'former',
        smk_status == 3L ~ 'current'
      ),
      smk_former = dplyr::if_else(smk_status == 'former', 1L, 0L),
      smk_ever = dplyr::if_else(smk_status == 'never', 0L, 1L),
      smk_status = factor(smk_status),
      smk_former = factor(smk_former),
      fev1fvc_p5 = fev1fvc / 5,
      smk_duration_p5 = smk_duration / 5,
      smk_cigpday_p10 = smk_cigpday / 10,
      smk_years_stop_p5 = smk_years_stop / 5
    )
  
  data_split <- 
    data_fmt %>%
    dplyr::mutate(.order = 1:dplyr::n()) %>% 
    dplyr::group_split(smk_ever)
    
  smk_never <- data_split[[1]]
  smk_ever <-  data_split[[2]]
  
  smk_never <- predictNS(smk_never, time)
  smk_ever <- predictES(smk_ever, time)
  
  data_preds <-
    dplyr::bind_rows(smk_never, smk_ever) %>% 
    dplyr::arrange(.order) %>% 
    dplyr::select(-.order)
  
  data_orig$ALARM_pred <- data_preds$ALARM_pred
  data_orig
}

predictNS <- function(data, time, ...) {
  if (!exists('.ALARM_NS')) .ALARM_NS <- ALARM_NS()
  data_nest <- dplyr::group_by(data, .order) %>% tidyr::nest()
  preds <- purrr::map_dbl(
    data_nest$data,
    ~ flexsurv::pmatrix.fs(
      x = .ALARM_NS,
      trans = attr(.ALARM_NS, 'trans'),
      t = time,
      newdata = .x
    )[1,2]
  )
  data_nest$ALARM_pred <- preds
  tidyr::unnest(data_nest, data) %>% 
    dplyr::ungroup()
}

predictES <- function(data, time, ...) {
  if (!exists('.ALARM_ES')) .ALARM_ES <- ALARM_ES()
  data_nest <- dplyr::group_by(data, .order) %>% tidyr::nest()
  preds <- purrr::map_dbl(
    data_nest$data,
    ~ flexsurv::pmatrix.fs(
      x = .ALARM_ES,
      trans = attr(.ALARM_ES, 'trans'),
      t = time,
      newdata = .x
    )[1,2]
  )
  data_nest$ALARM_pred <- preds
  tidyr::unnest(data_nest, data) %>% 
    dplyr::ungroup()
}

utils::globalVariables(
  c('age', 'sex', 'smk_former', 'fev1fvc',
    'smk_duration', 'smk_cigpday', 'smk_years_stop',
    'smk_ever', 'ALARM', '.order', 'smk_status',
    'predictNS', 'predictES')
)
