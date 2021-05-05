## Series of panel regression

# function extract the parameters of the regression for a given number of initial periods
run_panel_regression <- function(data, thresh, piesize){
  ar <- data %>% 
    filter(offer == 1) %>%
    filter(reaction != "Error") %>% 
    group_by(subject_ID, pie_size, .add = F) %>% 
    mutate(period = seq_along(subject_ID)) %>% 
    filter(period <= thresh) %>% 
    group_by(subject_ID,pie_size) %>%
    summarise(proba = mean(reaction == "Accept"))
  
  regdf <- data %>% 
    filter(offer == "1") %>% 
    filter(reaction != "Error") %>% 
    left_join(ar, by = c("subject_ID", "pie_size")) %>% 
    group_by(subject_ID, pie_size, .add = F) %>% 
    mutate(period = seq_along(subject_ID)) %>% 
    select(subject_ID, choice_N, everything())
  
  felm(reaction_time ~ proba + reaction + proba*reaction | subject_ID | 0 | subject_ID, 
       data = regdf %>% filter(pie_size %in% piesize)) %>% #  & period >thresh)) %>% 
    broom::tidy(conf.int = T)
}

# running for 20 different intervals: pie size 19
reg19 <- map_df(.x = seq(1:20), ~run_panel_regression(df,.x,19), .id = "threshold") %>% 
  mutate(pie = "Large pie (19€)")

# running for 20 different intervals: pie size 11
reg11 <- map_df(.x = seq(1:20), ~run_panel_regression(df,.x,11), .id = "threshold")%>% 
  mutate(pie = "Small pie (11€)")

# plotting the results
bind_rows(reg11, reg19) %>% 
  filter(term != "proba") %>% 
  mutate(term = case_when(term == "reactionReject" ~ "Reaction: reject",
                          term == "proba:reactionReject" ~ "%Accept(1:n) × reject")) %>% 
  mutate(term = as.factor(term),
         term = fct_relevel(term, "Reaction: reject")) %>% 
  mutate(threshold = as.integer(threshold)) %>% 
  ggplot(aes(threshold, estimate, color = term))+
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.25)+
  geom_point()+
  scale_color_grey(start = 0.1, end = 0.4)+
  geom_hline(yintercept = 0, color = "red", linetype = "dashed")+
  facet_grid(pie~term, scales = "free")+
  labs(x = "First n reactions", 
       y = "Parameter estimate")+
  theme(panel.grid.minor = element_blank(), legend.position = "none")

ggsave("Figures/Figure_4.png", width = 8, height = 6, units = "in", dpi = 600)

