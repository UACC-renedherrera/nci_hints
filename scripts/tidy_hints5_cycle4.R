# What does the NCI HINTS 5, Cycle 4 dataset tell us?
# René Dario Herrera
# University of Arizona Cancer Center 
# renedherrera at email dot arizona dot edu 

# set up ####
# packages 
library(here)
library(tidyverse)
library(haven)
library(janitor)

# prepare to read data 
# set values
url <- "https://hints.cancer.gov/dataset/HINTS5_Cycle4_SAS_20210309.zip"
path_zip <- "data/raw"
path_unzip <- "data/raw/HINTS5_Cycle4_SAS_20210309"
zip_file <- "HINTS5_Cycle4_SAS_20210309.zip"
# use curl to download
curl::curl_download(url, destfile = paste(path_zip, zip_file, sep = "/"))
# set value
zipped_file <- "data/raw/HINTS5_Cycle4_SAS_20210309.zip"
# unzip to folder
unzip(zipped_file, exdir = path_unzip)

# read data from file 
hints5_c4 <- read_sas(
  data_file = "data/raw/HINTS5_Cycle4_SAS_20210309/hints5_cycle4_public.sas7bdat"
) %>%
  clean_names()

# inspect 
glimpse(hints5_c4)


