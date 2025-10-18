library(readr)     # for read_csv
library(dplyr)     # for data manipulation
library(readxl)    # only needed if you use read_excel()

# Load required libraries
library(lubridate)
library(dplyr)

priority = function(){

# Set current datetime
current_datetime <- as.POSIXct("2025-10-17 22:14:00", tz = "America/New_York")

# Read the dataset
data <- read.csv("Hackathon_Data1.csv", stringsAsFactors = FALSE)

# Function to convert to proper time format
convert_time <- function(time_str) {
  time_str <- sprintf("%04d", as.numeric(time_str))
  
  # Extract hours and minutes
  hours <- substr(time_str, 1, 2)
  minutes <- substr(time_str, 3, 4)
  return(paste0(hours, ":", minutes, ":00"))
}

# Combine DateChecked and TimeChecked into a datetime column
data <- data %>%
  mutate(
    LastCheck = as.POSIXct(
      paste(DateChecked, convert_time(TimeChecked)),
      format = "%m-%d-%Y %H:%M:%S",
      tz = "America/New_York"
    )
  )

# Calculate time since last check (in hours)
data <- data %>%
  mutate(TimeSinceLastCheck = as.numeric(difftime(current_datetime, LastCheck, units = "hours")))

# Calculate hospital stay duration
data <- data %>%
  mutate(
    Admitted = as.POSIXct(
      paste(DateAdmitted, convert_time(TimeAdmitted)),
      format = "%m-%d-%Y %H:%M:%S",
      tz = "America/New_York"
    ),
    StayDuration = as.numeric(difftime(current_datetime, Admitted, units = "hours")),
    DurationPerCheck = StayDuration / Checks
  )

compute_score <- function(ISS, TimeWaited, CheckRatio,
                          w1 = 0.4, w2 = 0.33, w3 = 0.27,
                          ISS_max = 75, TimeWaited_max = 24, CheckRatio_max = 24) {
  
  # Normalize each value to 0–1 scale
  ISS_norm <- pmin(ISS / ISS_max, 1)
  TimeWaited_norm <- pmin(TimeWaited / TimeWaited_max, 1)
  CheckRatio_norm <- pmin(CheckRatio / CheckRatio_max, 1)
  
  # Weighted composite score
  score <- (w1 * ISS_norm) + (w2 * TimeWaited_norm) + (w3 * CheckRatio_norm)
  
  # Ensure score is also capped at 1
  score <- pmin(score, 1)
  
  return(score)
}

Score = compute_score(data$ISS, data$TimeSinceLastCheck, data$DurationPerCheck)

data <- data %>%
  mutate(Composite_Score = compute_score(data$ISS, data$TimeSinceLastCheck, data$DurationPerCheck))


finaldata <- data %>%
  select(PatientName, TimeSinceLastCheck,	ISS, Composite_Score)

patient_1 <- finaldata %>%  rename( HoursSinceChecked = TimeSinceLastCheck, InjurySeverityScore = ISS, PriorityScore = Composite_Score)

patient <- patient_1 %>%
  mutate(across(where(is.numeric), ~ round(.x, 3)))

return(patient)
}