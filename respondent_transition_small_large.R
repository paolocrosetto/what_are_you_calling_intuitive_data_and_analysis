# Figure 6

df %>% 
  # compute % of acceptances by subject
  filter(offer == 1) %>%
  group_by(subject_ID,pie_size, subject_type) %>%
  summarise(prob_accept = mean(reaction == "Accept")) %>% 
  # preparing data for plot
  group_by(subject_ID,  subject_type, pie_size) %>% 
  pivot_wider(names_from = pie_size, values_from = prob_accept) %>% 
  # plot
  ggplot(aes(`11`, `19`, fill = subject_type))+
  geom_point(pch = 21, size = 5, alpha = 0.8, color = "black")+
  geom_abline(slope = 1, linetype = "dashed")+
  scale_fill_manual(name = "", values = c("grey99", "grey33","grey1", "grey66"))+
  labs(x = "Probability of accepting a 1-euro offer from a pie of 11",
       y = "Probability of accepting a 1-euro offer from a pie of 19")+
  theme(panel.grid.minor = element_blank())

# save the figure
ggsave("Figures/Figure_6.png", width = 8, height = 5, units = "in")


## tests to show different behavior of types in the transition from small to large pie
df %>% 
  # compute % of acceptances by subject
  filter(offer == 1) %>%
  group_by(subject_ID,pie_size, subject_type) %>%
  summarise(prob_accept = mean(reaction == "Accept")) %>% 
  # test if acceptance rate is different 
  group_by(subject_type) %>% 
  group_modify(~tidy(wilcox.test(prob_accept~pie_size, data= .)))

