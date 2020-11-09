## Table 3
## (note: last column computed in the prop_expec_shares object)

# table using respondent data only
table3 <- table(df$pie_size,df$offer,df$reaction) %>% 
  ftable() %>% 
  as_tibble() %>% 
  pivot_wider(names_from = Var3, values_from = Freq) %>% 
  select(pie = Var1, offer = Var2, Accept, Reject, Error) %>% 
  mutate(percAccept = 100*Accept/(Accept + Reject))

# adding proposer expectations
table3 <- table3 %>% 
  bind_cols(prop_expec_shares[3]) %>% 
  rename(expecAccept = share)

table3 %>% 
  write_csv("Tables/Table_in_figure_3.csv")


## Figure 3
df %>% 
  # cosmetic changes to variables
  mutate(pie_size = as.factor(pie_size)) %>% 
  mutate(pie_size = fct_recode(pie_size, "pie size 11" = "11", "pie size 19" = "19")) %>% 
  mutate(offer = as_factor(offer),
         offer = fct_recode(offer, "Offer = 1" = "1", "Offer = 3" = "3", "Offer = 5" = "5")) %>% 
  mutate(reaction = fct_relevel(reaction, "Accept","Reject")) %>% 
  #plot
  ggplot(aes(x=fct_rev(offer), fill=fct_rev(reaction)))+
  geom_bar(position=position_stack(), color = "grey40", size = 0.2)+
  scale_fill_manual(name = "", values = c("grey99", "grey20", "grey80") )+
  ylab("Number of reactions")+xlab("")+
  facet_grid(pie_size~.)+
  coord_flip()+
  guides(fill = guide_legend(reverse = TRUE))+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank())

# saving the plot
ggsave("Figures/Figure_3.png", width = 8, height = 5, units = "in")

# cleaning
rm(prop_expec_shares, table3)
