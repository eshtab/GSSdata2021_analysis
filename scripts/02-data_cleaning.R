#### Preamble ####
# Purpose: Cleaning and filtering data for GSS 2021
# Author: Eshta Bhardwaj
# Date: April 21 2023
# Contact: eshta.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: Must already have raw 2021 GSS dataset downloaded

library(tidyverse)
library(janitor)
library(modelsummary)
library(lubridate)
library(readxl)

# read in data from inputs folder of R project
raw_GSS_data <-
  read_csv(
    file = "inputs/data/GSS2021.csv",
    show_col_types = FALSE,
  )
# remove unneeded variables
filtered_GSS_data <- raw_GSS_data |>
  select(year, id, sex, cohort, marital, degree, prestg10,
         childs, fechld, fepresch, fefam, meovrwrk, natchld)

# read in data that had to be downloaded separately from GSS portal
raw_data_addedvars <-
  read_excel(
    "./inputs/data/missing_2021_vars.xlsx", sheet=1,
    col_names= TRUE,col_types=NULL,skip= 0
  )

# remove unneeded rows
filtered_data_addedvars <- raw_data_addedvars |>
  filter(year == 2021)

# remove year column
filtered_data_addedvars <- filtered_data_addedvars |>
  select(id_, wrkstat, hrs1, evwork)

# rename id column
filtered_data_addedvars <- filtered_data_addedvars |>
  rename(
    id = id_,
  )

# join added rows with filtered_data on ID
cleaned_data <- merge(x=filtered_GSS_data,y=filtered_data_addedvars, 
             by="id")

# group age into categories
print(class(cleaned_data$cohort))

cleaned_data$cohort[cleaned_data$cohort >= 1910 & cleaned_data$cohort <1920] <- "1910-1919"
cleaned_data$cohort[cleaned_data$cohort >= 1920 & cleaned_data$cohort <1930] <- "1920-1929"
cleaned_data$cohort[cleaned_data$cohort >= 1930 & cleaned_data$cohort <1940] <- "1930-1939"
cleaned_data$cohort[cleaned_data$cohort >= 1940 & cleaned_data$cohort <1950] <- "1940-1949"
cleaned_data$cohort[cleaned_data$cohort >= 1950 & cleaned_data$cohort <1960] <- "1950-1959"
cleaned_data$cohort[cleaned_data$cohort >= 1960 & cleaned_data$cohort <1970] <- "1960-1969"
cleaned_data$cohort[cleaned_data$cohort >= 1970 & cleaned_data$cohort <1980] <- "1970-1979"
cleaned_data$cohort[cleaned_data$cohort >= 1980 & cleaned_data$cohort <1990] <- "1980-1989"
cleaned_data$cohort[cleaned_data$cohort >= 1990 & cleaned_data$cohort <2000] <- "1990-1999"
cleaned_data$cohort[cleaned_data$cohort >= 2000 & cleaned_data$cohort <2010] <- "2000-2009"
cleaned_data$cohort[cleaned_data$cohort >= 2010 & cleaned_data$cohort <2020] <- "2010-2019"

# replace codes with description 
unique(cleaned_data$sex)
cleaned_data$sex[cleaned_data$sex == 2] <- "Female"
cleaned_data$sex[cleaned_data$sex == 1] <- "Male"

unique(cleaned_data$marital)
cleaned_data$marital[cleaned_data$marital == 1] <- "Married"
cleaned_data$marital[cleaned_data$marital == 2] <- "Widowed"
cleaned_data$marital[cleaned_data$marital == 3] <- "Divorced"
cleaned_data$marital[cleaned_data$marital == 4] <- "Separated"
cleaned_data$marital[cleaned_data$marital == 5] <- "Never Married"

cleaned_data$cohort[cleaned_data$cohort == 9999] <- "Don't Know"

unique(cleaned_data$degree)
cleaned_data$degree[cleaned_data$degree == 0] <- "Less than High School"
cleaned_data$degree[cleaned_data$degree == 1] <- "High School"
cleaned_data$degree[cleaned_data$degree == 2] <- "Associate/Junior College"
cleaned_data$degree[cleaned_data$degree == 3] <- "Bachelors"
cleaned_data$degree[cleaned_data$degree == 4] <- "Graduate"

unique(cleaned_data$prestg10) #prestige of respondent's occupation
unique(cleaned_data$childs) #8 means 8 or more
cleaned_data$childs[cleaned_data$childs == 8] <- "8 or More"

unique(cleaned_data$fechld)
cleaned_data$fechld[cleaned_data$fechld == 1] <- "Strongly Agree"
cleaned_data$fechld[cleaned_data$fechld == 2] <- "Agree"
cleaned_data$fechld[cleaned_data$fechld == 3] <- "Disagree"
cleaned_data$fechld[cleaned_data$fechld == 4] <- "Strongly Disagree"

unique(cleaned_data$fepresch)
cleaned_data$fepresch[cleaned_data$fepresch == 1] <- "Strongly Agree"
cleaned_data$fepresch[cleaned_data$fepresch == 2] <- "Agree"
cleaned_data$fepresch[cleaned_data$fepresch == 3] <- "Disagree"
cleaned_data$fepresch[cleaned_data$fepresch == 4] <- "Strongly Disagree"

unique(cleaned_data$fefam)
cleaned_data$fefam[cleaned_data$fefam == 1] <- "Strongly Agree"
cleaned_data$fefam[cleaned_data$fefam == 2] <- "Agree"
cleaned_data$fefam[cleaned_data$fefam == 3] <- "Disagree"
cleaned_data$fefam[cleaned_data$fefam == 4] <- "Strongly Disagree"

unique(cleaned_data$meovrwrk)
cleaned_data$meovrwrk[cleaned_data$meovrwrk == 1] <- "Strongly Agree"
cleaned_data$meovrwrk[cleaned_data$meovrwrk == 2] <- "Agree"
cleaned_data$meovrwrk[cleaned_data$meovrwrk == 3] <- "Neither Agree Nor Disagree"
cleaned_data$meovrwrk[cleaned_data$meovrwrk == 4] <- "Disagree"
cleaned_data$meovrwrk[cleaned_data$meovrwrk == 5] <- "Strongly Disagree"

unique(cleaned_data$natchld)
cleaned_data$natchld[cleaned_data$natchld == 1] <- "Too Little"
cleaned_data$natchld[cleaned_data$natchld == 2] <- "About Right"
cleaned_data$natchld[cleaned_data$natchld == 3] <- "Too Much"

unique(cleaned_data$wrkstat)
cleaned_data$wrkstat[cleaned_data$wrkstat == '.s:  Skipped on Web'] <- 'Skipped on Web'
cleaned_data$wrkstat[cleaned_data$wrkstat == '.n:  No answer'] <- 'No answer'

unique(cleaned_data$hrs1)
cleaned_data$hrs1[cleaned_data$hrs1 == '.i:  Inapplicable'] <- 'Inapplicable'
cleaned_data$hrs1[cleaned_data$hrs1 == '.d:  Do not Know/Cannot Choose'] <- 'Do Not Know'
cleaned_data$hrs1[cleaned_data$hrs1 == '.s:  Skipped on Web'] <- 'Skipped on Web'
cleaned_data$hrs1[cleaned_data$hrs1 == '.n:  No answer'] <- 'No answer'
cleaned_data$hrs1[cleaned_data$hrs1 >= 0 & cleaned_data$hrs1 <10] <- "0-9"
cleaned_data$hrs1[cleaned_data$hrs1 >= 10 & cleaned_data$hrs1 <20] <- "10-19"
cleaned_data$hrs1[cleaned_data$hrs1 >= 20 & cleaned_data$hrs1 <30] <- "20-29"
cleaned_data$hrs1[cleaned_data$hrs1 >= 30 & cleaned_data$hrs1 <40] <- "30-39"
cleaned_data$hrs1[cleaned_data$hrs1 >= 40 & cleaned_data$hrs1 <50] <- "40-49"
cleaned_data$hrs1[cleaned_data$hrs1 >= 50 & cleaned_data$hrs1 <60] <- "50-59"
cleaned_data$hrs1[cleaned_data$hrs1 >= 60 & cleaned_data$hrs1 <70] <- "60-69"
cleaned_data$hrs1[cleaned_data$hrs1 >= 70 & cleaned_data$hrs1 <80] <- "70-79"
cleaned_data$hrs1[cleaned_data$hrs1 >= 80 & cleaned_data$hrs1 <90] <- "80-89"
cleaned_data$hrs1[cleaned_data$hrs1 >= 90] <- "More than 89"

unique(cleaned_data$evwork)
cleaned_data$evwork[cleaned_data$evwork == '.i:  Inapplicable'] <- 'Inapplicable'
cleaned_data$evwork[cleaned_data$evwork == '.s:  Skipped on Web'] <- 'Skipped on Web'
cleaned_data$evwork[cleaned_data$evwork == '.n:  No answer'] <- 'No answer'

# rename columns
colnames(cleaned_data)

cleaned_data <- cleaned_data |>
  rename(
    age = cohort,
    marital_status = marital,
    occ_prestige = prestg10,
    num_children = childs,
    op_working_mother = fechld,
    op_preschool = fepresch,
    op_family = fefam,
    op_childcare = natchld,
    work_status = wrkstat,
    hours_worked = hrs1,
    ever_worked = evwork,
    op_men_over_work = meovrwrk
  )

# write cleaned version of data to csv
write_csv(
  x = cleaned_data,
  file = "./inputs/data/cleaned_data.csv"
)