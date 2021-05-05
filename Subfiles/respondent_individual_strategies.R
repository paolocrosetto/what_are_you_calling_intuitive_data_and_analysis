## Figure 2

df %>% 
  # cosmetic changes to the variables
  mutate(pie_size = as.factor(pie_size)) %>% 
  mutate(pie_size = fct_recode(pie_size, "pie 11" = "11", "pie 19" = "19")) %>% 
  unite(category, pie_size, offer, sep = ": ") %>% 
  mutate(reaction = as.factor(reaction),
         reaction = fct_relevel(reaction, "Accept","Reject")) %>% 
  # plot
  ggplot(aes(x=fct_rev(category), fill=fct_rev(reaction)))+
  geom_bar(position='fill', width=.74, color = "grey40", size = 0.2)+
  facet_wrap(~subject_ID, nrow = 4)+
  scale_fill_manual(name = "", values = c("grey99", "grey20", "grey80") )+
  xlab("Offers conditional on pie size")+
  ylab("Frequency of accept, reject and errors")+
  scale_y_continuous(labels = scales::percent, breaks = c(0,0.5,1))+
  coord_flip()+
  guides(fill = guide_legend(reverse = TRUE))

# saving the plot
ggsave("Figures/Figure_2.png", width = 9, height = 12, units = "in", dpi = 600)


