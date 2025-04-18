#' Asian Lung Cancer Absolute Risk Models (ALARM)
#' 
#' These functions return ALARM model objects that can be used to make
#'   predictions of the *t*-year absolute risk of lung cancer mortality. These
#'   functions are called internally by [`predictALARM()`], if necessary.
#' 
#' @return ALARM model objects (i.e. a `list` with the class `fmsm`).
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
