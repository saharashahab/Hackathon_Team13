library(readr)     # for read_csv
library(dplyr)     # for data manipulation
library(lubridate)

source("PriorityTable.R")

ppk = function(data, current_datetime){
  current_date <- format(current_datetime, "%m-%d-%Y")
  current_time <- format(current_datetime, "%H%M")
  
  patient <- priority(data, current_datetime)
  
  high_priority_patients <- patient$PatientName[patient$PriorityScore > 0.675]
  
  updated_data <- data %>%
    mutate(
      DateChecked = ifelse(PatientName %in% high_priority_patients, current_date, DateChecked),
      TimeChecked = ifelse(PatientName %in% high_priority_patients, current_time, TimeChecked),
      Checks = ifelse(PatientName %in% high_priority_patients, Checks + 1, Checks)
    )
  
  new_patient <- priority(updated_data, current_datetime)
  
  ppk_val = abs(0.675 - mean(patient$PriorityScore))/(3*sd(patient$PriorityScore))
  predicted_ppk_val = abs(0.675 - mean(new_patient$PriorityScore))/(3*sd(new_patient$PriorityScore))
  
  return(c(ppk = ppk_val, predicted_ppk = predicted_ppk_val))
}