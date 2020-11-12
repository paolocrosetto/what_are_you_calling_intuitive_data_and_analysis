# Figure

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
ggsave("Figures/Figure_1.png", width = 8, height = 5, units = "in")


# Table and tests

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
