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


### data input ####

#getting data
setwd("/home/paolo/Dropbox/Progetti Werner/NeuroEconomics/4 - Analysis/")
df<-read_csv('NeuroData.csv')

# ggplot theme
theme_set(theme_ipsum_rc()+
            theme(legend.position = "bottom"))

#renaming
df <- df %>% 
  rename("largepie" = Role,
         "pie" = endowment,
         "offer" = choice,
         "belief" = Belief,
         "faculty" = Studium,
         "semester" = Semesterzahl,
         "age" = Alter,
         "female" = Geschlecht,
         "session" = Session,
         "trust"  = Trustindex)

# factors
df <- df %>% 
  mutate(pie = as_factor(pie),
         largepie = as_factor(largepie),
         belief = as_factor(belief),
         belief = fct_recode(belief, "accept" = "0","reject" = "1"),
         offer_num = offer,
         offer = as_factor(offer),
         offer = fct_recode(offer, "Offer = 1" = "1", "Offer = 3" = "3", "Offer = 5" = "5"),
         female = as_factor(female),
         female = fct_recode(female, "male" = "0", "female" = "1"),
         pie = fct_recode(pie, "pie size 11" = "11", "pie size 19" = "19")
         )


#other changes
df <- df %>% 
  mutate(SVO = SVO*180/pi) %>% 
  mutate(SVO_cat = cut(SVO, c(-1000,-12.04,22.45,57.15,1000 ))) %>% 
  mutate(SVO_cat = fct_recode(SVO_cat,
                              "competitive" = "(-1e+03,-12]",
                              "individualist" = "(-12,22.4]",
                              "prosocial" = "(22.4,57.1]",
                              "altruist" = "(57.1,1e+03]"))
         
         
#### proposers ####

# figure 1

#basic distribution of offers including beliefs
df %>% 
  group_by(pie, offer, belief, .drop = F) %>% 
  summarise(count = n()) %>% 
  mutate(belief = fct_recode(belief, "expecting acceptance" = "accept",
                             "expecting rejection" = "reject")) %>% 
  ggplot(aes(fct_rev(offer), count, fill=fct_rev(belief)))+
  geom_col(position=position_stack())+
  scale_fill_grey(name = "", start = 0.2, end = 0.8)+
  ylab("number of offers")+xlab("")+
  coord_flip()+
  facet_grid(pie~.)+
  guides(fill = guide_legend(reverse = TRUE))+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank())
ggsave("proposer_distribution_offers_beliefs.png", width = 8, height = 5, units = "in")


# tests related to figure 1

# same share of 3-offers irrespective of pie size
df %>% 
  filter(offer_num == 3) %>% 
  group_by(pie) %>% 
  tally() %>% 
  mutate(p = 100*n/120)


#share of 1- and 5-offers
df %>% 
  filter(offer_num != 3) %>% 
  group_by(offer_num, pie) %>% 
  tally()

# they differ drastically by pie:
df %>% 
  filter(offer_num != 3) %$% 
  fisher.test(offer_num, pie) %>% 
  tidy()


# figure 2

#the role of SVO: angle
ggplot(df, aes(x=fct_rev(offer),y=SVO))+
  geom_quasirandom(alpha = 0.7)+
  geom_boxplot(aes(alpha = 0))+
  scale_alpha(guide = F)+
  facet_grid(pie~.)+
  geom_hline(yintercept=c(22.45,57.15), lty=2, col="grey")+
  annotate("text",x=0.5,y=0, label="individualists", angle=0)+
  annotate("text",x=0.5,y=40, label="prosocials", angle=0)+
  annotate("text",x=0.5,y=68, label="altruists", angle=0)+
  ylab("SVO angle")+xlab("")+
  coord_flip(ylim=c(-10,75))+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_blank())
ggsave("SVO_nogrid.png", width = 10, height = 6, units = "in")

# data related to figure 2

# table of types
df %>% 
  group_by(SVO_cat) %>% 
  tally()

# table of types by pie_size
df %>% 
  group_by(pie, SVO_cat) %>% 
  tally() %>% 
  pivot_wider(names_from = SVO_cat, values_from = n)

# test of the table by pie size
fisher.test(table(df$pie, df$SVO_cat)) %>% tidy()
chisq.test(df$pie, df$SVO_cat) %>% tidy()

# correlation between types and offer

# overall
cor.test(df$SVO, df$offer_num, method = "kendall") %>% tidy()

# by pie size
df %>% 
  group_by(pie) %>% 
  group_modify(~tidy(cor.test(.$SVO, .$offer_num, method = "kendall")))


### additional analysis if needed

## regression
reg <- lm(as.numeric(as.character(offer)) ~ pie + SVO + trust, data = df)
library(huxtable)
huxreg(reg)

library(nnet)
reg <- multinom(offer ~ pie + SVO + trust, data = df)
huxreg(reg)

  