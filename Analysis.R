#########################################################
# Data and scripts for 
# What are you calling intuitive?
# Subject Heterogeneity as a Driver of Response Time in an impunity game
# by Paolo Crosetto and Werner Güth
#########################################################

## needed libraries
library(tidyverse)      # R dialect used in this script
library(hrbrthemes)     # theme for plots
library(broom)          # tidies statistical output
library(magrittr)       # extra pipes to streamline code
library(lfe)            # panel estimation with clustered standard errors

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
source("Subfiles/proposer_data_cleaning.R")
         
## Distribution of offers: Table and tests
source("Subfiles/proposer_offers.R")

#################
# Extra results that are not discussed in the paper
#################
#
# ## Distribution of proposals -- plot and tests
# source("Subfiles/proposer_offers_old.R")
# 
# ## Proposers expectations of respondent behavior -- plot and tests
# source("Subfiles/proposer_estimated_acceptances.R")
# 
# ## Proposer's SVO -- plot and tests
# source("Subfiles/proposer_SVO.R")


#####################
## RESPONDENTS
## data come from an fMRI experiment ran in Jena, Germany
## 
  
## getting the raw data
df <- read_csv("Data/respondents.csv")

## data cleaning
source("Subfiles/respondent_data_cleaning.R")

## Distribution of reactions: Table and Figure 3
source("Subfiles/respondent_reactions.R")

## Individual strategies: Figure 4
source("Subfiles/respondent_individual_strategies.R")

## Strategy by type: Figure 5 
source("Subfiles/respondent_types.R")

## Transition from small to large pies by type: Figure 6 and relative tests
source("Subfiles/respondent_transition_small_large.R")

## Reaction times: Table 1, Table 2 and relative tests
source("Subfiles/respondent_time.R")

## Share of acceptances and reaction time: Figure 7 and regression analysis Table 3
source("Subfiles/respondent_self_prime.R")

#################
# Extra results that are not discussed in the paper
#################
#
# visual representation of the regression result via a simple plot of averages
# source("Subfiles/respondent_visual_plot_self_prime.R")