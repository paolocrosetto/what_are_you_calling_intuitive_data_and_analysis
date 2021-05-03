# Figure
library(ggbeeswarm)      # jitter with structure

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
ggsave("Figures/Figure_2.png", width = 10, height = 6, units = "in")



# Tables and tests

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

