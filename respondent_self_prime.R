## Figure 7

# ratio of acceptances by subject -- 1-euro offers
acceptance_ratio <- df %>% 
  filter(offer == 1) %>%
  group_by(subject_ID,pie_size, offer) %>%
  summarise(prob_accept = mean(reaction == "Accept"))

# reaction time -- 1-euro offers
reaction_time <- df %>% 
  filter(offer == 1) %>% 
  select(subject_ID, pie_size, offer, reaction_time, reaction) %>% 
  group_by(subject_ID, pie_size, offer, reaction) %>% 
  filter(reaction != "Error") %>% 
  summarise(time = mean(reaction_time, na.rm = T))

# merging
reaction_and_acceptance <- reaction_time %>% 
  left_join(acceptance_ratio, by = c("subject_ID", "pie_size", "offer"))

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

#cleaning


## Table 3 

# column 1: pie size 11
fit11 <- reaction_and_acceptance %>%  
  filter(pie_size == 11) %>% 
  lm(time~prob_accept*reaction, data= .)

# column 2: pie size 19
fit19 <- reaction_and_acceptance %>%  
  filter(pie_size == 19) %>% 
  lm(time~prob_accept*reaction, data= .)

# export to csv file
tidy(fit11) %>% 
  mutate(column = "pie = 11") %>% 
  bind_rows(tidy(fit19) %>% mutate(column = "pie = 19")) %>% 
  select(column, everything()) %>% 
  write_csv("Tables/Table_3.csv")

# export to latex
library(stargazer)
stargazer(fit11, fit19, title = "Response time as a function of the frequency of acceptance -- offers of 1", 
          column.labels = c("Pie size 11", "Pie size 19"))


rm(acceptance_ratio, reaction_time, reaction_and_acceptance, fit11, fit19)

