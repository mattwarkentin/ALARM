#! /usr/local/bin/Rscript --vanilla

library(targets)
library(purrr)
library(withr)
library(here)

with_dir(
  new = '/Users/matt/Documents/china-kadoorie-biobank/',
  code = {
    alarm_es <- tar_read(msm_ever)
    alarm_es[[1]]$logliki <- NULL
    alarm_es[[1]]$data <- NULL
    alarm_es[[2]]$logliki <- NULL
    alarm_es[[2]]$data <- NULL
    
    alarm_ns <- tar_read(msm_never)
    alarm_ns[[1]]$logliki <- NULL
    alarm_ns[[1]]$data <- NULL
    alarm_ns[[2]]$logliki <- NULL
    alarm_ns[[2]]$data <- NULL
    
    saveRDS(alarm_es, file = here('inst/models/ALARM_ES.rds'))
    saveRDS(alarm_ns, file = here('inst/models/ALARM_NS.rds'))
  }
)
