#! /usr/local/bin/Rscript --vanilla

library(targets)
library(withr)
library(here)

with_dir(
  new = '/Users/matt/Documents/china-kadoorie-biobank/',
  code = {
    alarm_es <- tar_read(fpsm_ever)
    alarm_es$data <- NULL
    alarm_es$logliki <- NULL
    
    alarm_ns <- tar_read(fpsm_never)
    alarm_ns$data <- NULL
    alarm_ns$logliki <- NULL
    
    saveRDS(alarm_es, file = here('inst/models/ALARM_ES.rds'))
    saveRDS(alarm_ns, file = here('inst/models/ALARM_NS.rds'))
  }
)
