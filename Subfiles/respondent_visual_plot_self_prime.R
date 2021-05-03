## Figure 7

# ratio of acceptances by subject -- 1-euro offers
acceptance_ratio <- df %>% 
  filter(offer == 1) %>%
  filter(reaction != "Error") %>% 
  group_by(subject_ID, pie_size, .add = F) %>%
  mutate(period = seq_along(subject_ID)) %>%
  filter(period <= 5) %>%
  group_by(subject_ID,pie_size) %>%
  summarise(prob_accept = mean(reaction == "Accept"))
# group_by(subject_ID,pie_size) %>%
# summarise(prob_accept = mean(reaction == "Accept"))

# reaction time -- 1-euro offers
reaction_time <- df %>% 
  filter(offer == 1) %>% 
  filter(reaction != "Error") %>% 
  group_by(subject_ID, pie_size, .add = F) %>% 
  mutate(period = seq_along(subject_ID)) %>% 
  select(subject_ID, pie_size, reaction_time, reaction) %>% 
  group_by(subject_ID, pie_size, reaction) %>% 
  filter(reaction != "Error") %>% 
  summarise(time = mean(reaction_time, na.rm = T))

# merging
reaction_and_acceptance <- reaction_time %>% 
  left_join(acceptance_ratio, by = c("subject_ID", "pie_size"))

# plot
reaction_and_acceptance %>% 
  mutate(pie_size = as.factor(pie_size),
         pie_size = fct_recode(pie_size, "Pie size 11" = "11", "Pie size 19" = "19")) %>% 
  ggplot(aes(prob_accept, time, color = pie_size, fill = pie_size))+
  geom_point(pch = 21, size=3, alpha = .8)+
  geom_smooth(method = "glm", fill = 'grey40', alpha = 0.1, formula = 'y ~ x')+
  facet_wrap(~reaction)+
  scale_x_continuous(labels = scales::percent, breaks = seq(0,1,.2))+
  scale_color_grey(name ="", start = 0.8, end = 0.2)+
  scale_fill_grey(name ="", start = 0.8, end = 0.2)+
  labs(x = "Share of accepted offers in the first 5 responses",
       y = "Average reaction time")+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank())

# saving the plot
ggsave("Figures/Figure_7_new.png", width = 8, height = 5, units = "in")
