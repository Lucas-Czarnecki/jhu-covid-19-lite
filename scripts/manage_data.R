# This script is used to import and consolidate all daily reports into a single data frame. It also adds new variables to the dataset.

# setup -------------------------------------------------------------------

# package management
if(!require(pacman, quietly = TRUE)) install.packages("pacman")
pacman::p_load(tidyverse)

# import daily reports 
csv_files <- list.files("~/GitHub/jhu-covid-19-lite/data/daily_reports", pattern = "*.csv", full.names = TRUE)

daily_reports <- lapply(csv_files, function(file) {
  read.csv(file, colClasses = c(FIPS = "character"))
}) %>% 
  bind_rows()

#import lookup table
lookup_table <- read_csv("data/supporting_material/lookup_table.csv")

# process data ------------------------------------------------------------

# df <- daily_reports %>% sample_n(100)

# add population statistics
daily_reports$Population <-  lookup_table$Population[match(daily_reports$Combined_Key, lookup_table$Combined_Key)]

# Encode and organize columns   
daily_reports <- daily_reports %>%
  mutate(Province_State = as.factor(Province_State),
         Date_Published = as.Date(Date_Published, format = "%m-%d-%Y"),
         Country_Region = as.factor(Country_Region),
         ) %>% 
  relocate(Population, .after = Active)

# add additional variables
daily_reports <- daily_reports %>% 
  mutate(Incident_Rate = ifelse(Confirmed > 0 & !is.na(Population),
                                Confirmed / Population * 100000,
                                NA),
         # Quality control: You cannot have more deaths than cases
         Case_Fatality_Ratio = ifelse(Deaths <= Confirmed & !is.na(Confirmed),
                                      Deaths / Confirmed * 100,
                                      NA)) %>% 
  relocate(Incident_Rate:Case_Fatality_Ratio, .after = Population)

str(daily_reports)

# quality control ---------------------------------------------------------

# remove columns discontinued by JHU
daily_reports <- daily_reports %>% 
  select(-Active, -Recovered)

# export data frame -------------------------------------------------------

saveRDS(daily_reports, "jhu_covid19_main.RDS")




