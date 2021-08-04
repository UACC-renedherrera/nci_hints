# What does the NCI HINTS 5, Cycle 3 dataset tell us?
# René Dario Herrera
# University of Arizona Cancer Center 
# renedherrera at email dot arizona dot edu 

# set up ####
# packages 
library(here)
library(tidyverse)
library(haven)
library(janitor)

# # prepare to read data 
# # set values
# url <- "https://hints.cancer.gov/dataset/HINTS5_Cycle3_SAS_20210305.zip"
# path_zip <- "data/raw"
# path_unzip <- "data/raw/HINTS5_Cycle3_SAS_20210305"
# zip_file <- "HINTS5_Cycle3_SAS_20210305.zip"
# # use curl to download
# curl::curl_download(url, destfile = paste(path_zip, zip_file, sep = "/"))
# # set value
# zipped_file <- "data/raw/HINTS5_Cycle3_SAS_20210305.zip"
# # unzip to folder
# unzip(zipped_file, exdir = path_unzip)

# read data from file 
hints5_c3 <- read_sas(
  data_file = "data/raw/HINTS5_Cycle3_SAS_20210305/hints5_cycle3_public.sas7bdat"
) %>%
  clean_names()

# inspect 
class(hints5_c3)
glimpse(hints5_c3)

# looking for health info?
hints5_c3 %>%
  filter(seek_health_info == 1) %>%
  mutate(where_seek_health_info_label = as_factor(if_else(
    where_seek_health_info == 1, "books",
    if_else(where_seek_health_info == 2, "brochures",
            if_else(where_seek_health_info == 3, "cancer org",
                    if_else(where_seek_health_info == 4, "family",
                            if_else(where_seek_health_info == 5, "friend or coworker",
                                    if_else(where_seek_health_info == 6, "provider",
                                            if_else(where_seek_health_info == 7, "internet",
                                                    if_else(where_seek_health_info == 8, "library",
                                                            if_else(where_seek_health_info == 9, "magazines",
                                                                    if_else(where_seek_health_info == 10, "newspapers",
                                                                            if_else(where_seek_health_info == 11, "telephone info",
                                                                                    if_else(where_seek_health_info == 12, "cam provider", "NA"
    )))))))))))))) %>%
  filter(where_seek_health_info_label != "NA") %>%
  mutate(health_info_label = fct_lump(where_seek_health_info_label, n = 5)) %>%
  count(health_info_label) %>%
  arrange(desc(n))

# demographics
# sex
hints5_c3 %>%
  mutate(
    gender_label = if_else(
      self_gender == "1", "Male",
      if_else(self_gender == "2", "Female", "NA"))
  ) %>%
  count(gender_label)

# race
hints5_c3 %>%
  mutate(
    hispanic = as_factor(if_else(
      hisp_cat == -9, "NA",
      if_else(hisp_cat == -7, "NA",
              if_else(hisp_cat == 10, "Not Hispanic", "Hispanic")))
      ),
    race = as_factor(if_else(
      white == "1", "white",
      if_else(amer_ind == "1", "aian",
              if_else(black == "1", "black", "Other"))))
    ) %>%
  count(hispanic, race)
  
