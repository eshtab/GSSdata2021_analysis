#### Preamble ####
# Purpose: Download for 2021 GSS data
# Author: Eshta Bhardwaj
# Date: April 21 2023
# Contact: eshta.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to know info for downloading dataset from GSS


#### Workspace setup ####
# install.packages("haven") 
library(haven)

# read dta file downloaded from GSS 
# source: https://gss.norc.org/get-the-data
raw_data = read_dta("./inputs/data/GSS2021.dta")

# convert dta to csv
# code source: https://stackoverflow.com/questions/2536047/convert-a-dta-file-to-csv-without-stata-software
write.csv(raw_data, file = "./inputs/data/GSS2021.csv")

