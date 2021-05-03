## Figure 4

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
ggsave("Figures/Figure_4.png", width = 9, height = 12, units = "in", dpi = 600)

## alternative fig 4 with acceptance rate only
plot_1_subject = function(sub){
  df %>% 
    mutate(reaction = as.factor(reaction), pie_size = as.factor(pie_size), offer = as.factor(offer)) %>% 
    group_by(subject_ID, pie_size, offer, reaction, .drop = F)   %>% 
    tally() %>% 
    mutate(N = sum(n), shareaccept = n/N) %>% 
    filter(reaction == "Reject") %>% 
    select(subject_ID, pie_size, offer, shareaccept) %>% 
    # cosmetic changes to the variables
    mutate(pie_size = fct_recode(pie_size, "Small pie (11€)" = "11", "Large pie (19€)" = "19")) %>% 
    mutate(offer = fct_recode(offer, "Low (1€)" = "1", "Medium (3€)" = "3", "Large (5€)" = "5")) %>% 
    mutate(category = paste(pie_size, offer, sep = ": ")) %>% 
    # subset
    filter(subject_ID == sub) %>% 
    # plot
    ggplot(aes(x=fct_rev(offer), shareaccept))+
    geom_segment(aes(xend = fct_rev(offer), y = 0, yend = shareaccept), color = "grey50")+
    geom_point(size = 3)+
    facet_grid(.~pie_size)+
    labs(x = "", y = "rejection rate", title = sprintf("Subject %s",sub))+
    scale_y_continuous(labels = scales::percent, breaks = c(0,0.5,1), limits = c(0,1))+
    #scale_x_discrete(expand = c(0.1, 3.1))+
    coord_flip()+
    theme(panel.grid.minor = element_blank(), panel.grid.major.y = element_blank())
}

plots = lapply(seq(1:24), plot_1_subject)

p <- gridExtra::grid.arrange(plots[[1]],plots[[2]], plots[[3]], plots[[4]],
                        plots[[5]],plots[[6]], plots[[7]], plots[[8]],
                        plots[[9]],plots[[10]], plots[[11]], plots[[12]],
                        plots[[13]],plots[[14]], plots[[15]], plots[[16]],
                        plots[[17]],plots[[18]], plots[[19]], plots[[20]],
                        plots[[21]],plots[[22]], plots[[23]], plots[[24]], ncol = 4)
ggsave("tryme.png", plot = p, width = 11.69*2, height = 8.27*2, units = "in", dpi = 600)


