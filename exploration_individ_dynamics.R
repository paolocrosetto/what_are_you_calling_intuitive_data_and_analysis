
df %>% 
  as_tibble() %>% 
  filter(offer == 1) %>% 
  filter(reaction != "Error") %>% 
  group_by(subject_ID, pie_size) %>% 
  mutate(period = seq_along(subject_ID)) %>% 
  filter(subject_ID == 13) %>% 
  ggplot(aes(period, reaction_time, color = reaction)) +
  geom_point()+
  geom_line()+
  geom_smooth()+
  facet_grid(subject_ID~pie_size)
