#########################################################
# Data and scripts for 
# What are you calling intuitive?
# Subject Heterogeneity as a Driver of Response Time in an impunity game
# by Paolo Crosetto and Werner Güth
#########################################################

## needed libraries
library(tidyverse)      # R dialect usd in this script
library(hrbrthemes)     # theme for plots
library(ggbeeswarm)     # cool jittered plots -- used for Figure 2
library(broom)          # tidies statistical output -- just for visualization
library(magrittr)       # extra pipes to streamline code

## ggplot theme
theme_set(theme_ipsum_rc()+
            theme(legend.position = "bottom"))

#####################
## PROPOSERS
## data come from a laboratory experiment ran in Jena, Germany
## 

## getting raw data
df<-read_csv('Data/proposers.csv')

## data cleaning
source("proposer_data_cleaning.R")
         
## Distribution of offers: figure 1 and relative tests
source("proposer_offers.R")

## SVO
source("proposer_SVO.R")


#####################
## RESPONDENTS
## data come from an fMRI experiment ran in Jena, Germany
## 
  