## Figure 5

df %>%
  # counting subjects by type
  group_by(subject_type) %>% 
  mutate(n = n()/240) %>% 
  mutate(subject_typeN = paste(subject_type, " (", n, ")", sep = "")) %>% 
  # cosmetic changes to variables
  mutate(pie_size = as.factor(pie_size)) %>% 
  mutate(pie_size = fct_recode(pie_size, "pie size 11" = "11", "pie size 19" = "19")) %>% 
  mutate(offer = as_factor(offer),
         offer = fct_recode(offer, "Offer = 1" = "1", "Offer = 3" = "3", "Offer = 5" = "5")) %>% 
  mutate(reaction = fct_relevel(reaction, "Accept","Reject")) %>% 
  # plot
  ggplot(aes(x=fct_rev(offer), fill=fct_rev(reaction)))+
  geom_bar(position='fill', width=.74, color = "grey40", size = 0.2)+
  facet_grid(pie_size~subject_typeN)+
  scale_fill_manual(name = "", values = c("grey99", "grey20", "grey80") )+
  xlab("Offers conditional on pie size")+
  ylab("Frequency of accept, reject and errors")+
  scale_y_continuous(labels = scales::percent)+
  coord_flip()+
  guides(fill = guide_legend(reverse = TRUE))

#saving the plot
ggsave("Figures/Figure_5.png", width = 8.5, height = 5, units = "in")
