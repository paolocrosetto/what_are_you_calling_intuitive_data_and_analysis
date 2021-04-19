## Figure 7

# ratio of acceptances by subject -- 1-euro offers
acceptance_ratio <- df %>% 
  filter(offer == 1) %>%
  group_by(subject_ID,pie_size) %>%
  summarise(prob_accept = mean(reaction == "Accept"))

# reaction time -- 1-euro offers
reaction_time <- df %>% 
  filter(offer == 1) %>% 
  select(subject_ID, pie_size, reaction_time, reaction) %>% 
  group_by(subject_ID, pie_size, reaction) %>% 
  filter(reaction != "Error") %>% 
  summarise(time = mean(reaction_time, na.rm = T))

# merging
reaction_and_acceptance <- reaction_time %>% 
  left_join(acceptance_ratio, by = c("subject_ID", "pie_size")) %>% 
  mutate(reaction = fct_relevel(reaction, "Accept"))

# plot
reaction_and_acceptance %>% 
  mutate(pie_size = as.factor(pie_size),
         pie_size = fct_recode(pie_size, "Pie size 11" = "11", "Pie size 19" = "19")) %>% 
  ggplot(aes(prob_accept, time, color = reaction, fill = reaction))+
  geom_point(pch = 21, size=3, alpha = .8)+
  geom_smooth(method = "glm", fill = 'grey40', alpha = 0.1, formula = 'y ~ x')+
  facet_wrap(~pie_size)+
  scale_x_continuous(labels = scales::percent)+
  scale_color_grey(name ="", start = 0.8, end = 0.2)+
  scale_fill_grey(name ="", start = 0.8, end = 0.2)+
  labs(x = "Share of accepted offers",
       y = "average time of acceptances and rejections")+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank())

# saving the plot
ggsave("Figures/Figure_7.png", width = 8, height = 5, units = "in")


## Panel regression

# focus on data for 1-€ offers
regdf <- df %>% 
  filter(offer == "1") %>% 
  filter(reaction != "Error") %>% 
  select(subject_ID, choice_N, everything())


# merge prob_accpet with data
regdf <- regdf %>% 
  left_join(acceptance_ratio, by = c("subject_ID", "pie_size"))


# we regress the reaction time on
# the reaction (time-variant) interacted with the share of acceptances of each subject (time-invariant)
# there is within-subject variability, so we opt for a random effect model

# handling panel data with the plm library
library(plm)

## pie size of 11

# RE
random_effect_est_11 <- plm(reaction_time ~ prob_accept*reaction, data = regdf %>% filter(pie_size == 11), effect = "individual", model = "random") 

# FE
fixed_effect_est_11 <- plm(reaction_time ~ prob_accept*reaction, data = regdf %>% filter(pie_size == 11), model = "within") 

# test indicates we should prefer RE (p-value 0.8414)
phtest(random_effect_est_11, fixed_effect_est_11)

# clustered standard errors

ref_11_cluster <- coeftest(random_effect_est_11, vcov=vcovHC(ref,type="HC0",cluster="group"))


# pie size of 19
# RE
random_effect_est_19 <- plm(reaction_time ~ prob_accept*reaction, data = regdf %>% filter(pie_size == 19), effect = "individual", model = "random") 

# FE
fixed_effect_est_19 <- plm(reaction_time ~ prob_accept*reaction, data = regdf %>% filter(pie_size == 19), model = "within") 

# test indicates we should prefer RE (p-value 0.7934)
phtest(random_effect_est_19, fixed_effect_est_19)

# clustered standard errors
ref_19_cluster <- coeftest(random_effect_est_19, vcov=vcovHC(ref,type="HC0",cluster="group"))


# output to latex -- tweaked manually for the paper but all is here
library(stargazer)
stargazer(random_effect_est_11, ref_11_cluster, random_effect_est_19, ref_19_cluster,
          title = "Response time as a function of the frequency of acceptance -- offers of 1", 
          column.labels = c("Pie size 11", "clust SE", "Pie size 19", "clust SE"))

# cleaning up
rm(acceptance_ratio, reaction_time, reaction_and_acceptance, 
   random_effect_est_11, random_effect_est_19,
   fixed_effect_est_11, fixed_effect_est_19,
   ref_11_cluster, ref_19_cluster)

