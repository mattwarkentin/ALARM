#' Asian Lung Cancer Absolute Risk Models
#' 
#' These functions return ALARM model objects that can be used to make
#'   predictions of the *t*-year absolute risk of lung cancer mortality.
#' 
#' @return ALARM model objects (i.e. a `list` with the class `flexsurvreg`).
#' 
#' @name ALARM
#' @md
#' 
#' @export
ALARM_NS <- function() {
  readRDS(system.file('models/ALARM_NS.rds', package = 'ALARM'))
}

#' @rdname ALARM
#' @export
ALARM_ES <- function() {
  readRDS(system.file('models/ALARM_ES.rds', package = 'ALARM'))
}
