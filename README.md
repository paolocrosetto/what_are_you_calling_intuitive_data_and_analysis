# Data and analysis scripts for "What are you calling intuitive -- Subject heterogeneity as a driver of response times in an impunity game" by Paolo Crosetto and Werner Güth

This repository contains all data and scripts to reproduce the analysis contained in the paper *What are you calling intuitive? Subject heterogeneity as a driver of response times in an impunity game*, by Paolo Crosetto and Werner Güth.

## How to run the analysis

The whole analysis is contained in the file Analysis.R. This file calls all other R files. These analysis subfiles are stored in `/Subfiles`. Figures are saved in the `/Figure` subfolder, Tables in `/Tables`. The data for the respondent and the proposer are located in `/Data`. Tests are run inline and you need to execute the respective .R analysis subfile to see them appear in your console.

## The Paper

#### Abstract

*We study choices and reaction times of respondents in an impunity game with unfair offers. The non-private impunity game features two roles, proposer and respondent, who are both aware whether the pie size is small or large. Proposers decide among three more or less unfair offers; respondents can accept or reject the offer, which in the latter case is lost for both. Whatever the responder decides is communicated to the proposer.*

*240 proposers took part in a traditional laboratory; 24 respondents were in an fMRI setup where they confronted all 240 proposals elicited from proposers. Responses were sent via email to proposers.*

*Proposers revealed little concern for respondents. Respondents overwhelmingly rejected small offers, especially from a large pie. In contrast with most of the literature and the Social Heuristic Hypothesis, we find that on average rejections took longer than acceptances. This result is driven by individual heterogeneity. The rich response data allow us to distinguish different respondent types, finding a remarkable consistency: subjects mainly accepting (rejecting) take more time to reject (accept). We attribute this finding to heterogeneity in self-priming. Our results suggest a primary role for individual heterogeneity in experiments testing the intuitive or deliberate status of how they resolve conflict between opportunism and what seems socially right.*

#### Data

The paper analyses data from an *impunity game* experiment ran in 2011 over two different laboratories:

-   the Max Planck Experimental Economics Laboratory in Jena, where *proposer* participants decided how to split a pie of 11 or 19 € with a *respondent*. [Proposer data](Data/proposers.csv)

-   the fMRI scanner of the Klinikum der Universität Jena, where *respondents* faced all offers by proposers and decided either to *accept* the split or to *reject* it, in which case they burned their own money to send a message to the proposer. [Data/respondents.csv](Data/respondents.csv)

Proposers were then notified by email of the reaction of the respondent, that had no monetary consequences for them.

#### 
