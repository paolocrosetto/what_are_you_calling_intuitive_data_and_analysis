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
         
## Distribution of offers: Figure 1 and relative tests
source("proposer_offers.R")

## Expectations of rejections by proposers
source("proposer_estimated_acceptances.R")

## SVO: Figure 2 and relative tests
source("proposer_SVO.R")


#####################
## RESPONDENTS
## data come from an fMRI experiment ran in Jena, Germany
## 
  
## getting the raw data
df <- read_csv("Data/respondents.csv")

## data cleaning
source("respondent_data_cleaning.R")

## Distribution of reactions: Table and Figure 3
source("respondent_reactions.R")

## Individual strategies: Figure 4
source("respondent_individual_strategies.R")

## Strategy by type: Figure 5
source("respondent_types.R")

## Transition from small to large pies by type: Figure 6
source("respondent_transition_small_large.R")

## Reaction times: Table 1 & Table 2
source("respondent_time.R")

## Share of acceptances and reaction time: Figure 7 and regression analysis Table 3
source("respondent_self_prime.R")
