### Table 1  -- response time 

# changing order of response factor for better reporting
df <- df %>% 
  mutate(reaction = as.factor(reaction),
         reaction = fct_relevel(reaction, "Reject", "Accept"))

## first part: all observations

# table
T1_all <- df %>% 
  group_by(reaction) %>% 
  summarise(time = mean(reaction_time), 
            sd = sd(reaction_time),
            N=length(reaction_time)) %>% 
  mutate(pie_size = "all", offer = "all") %>% 
  select(pie_size, offer, everything())

# test
T1_all_test <- df %>% 
  filter(reaction != "Error") %>% 
  mutate(accept = reaction == "Accept") %>% 
  ungroup() %>% 
  group_modify(~tidy(wilcox.test(.$reaction_time~.$accept, paired=F))) %>% 
  select(p.value) 

# merge
T1_all <- T1_all %>% bind_cols(T1_all_test)


## second part: by pie size

# table
T1_pie <- df %>% 
  group_by(reaction, pie_size) %>% 
  summarise(time = mean(reaction_time), 
            sd = sd(reaction_time),
            N=length(reaction_time)) %>% 
  mutate(offer = "all", pie_size = as.character(pie_size)) %>% 
  select(pie_size, offer, everything()) %>% 
  arrange(pie_size)

# test
T1_pie_test <- df %>% 
  filter(reaction != "Error") %>% 
  mutate(accept = reaction == "Accept") %>% 
  group_by(pie_size) %>% 
  group_modify(~tidy(wilcox.test(.$reaction_time~.$accept, paired=F))) %>% 
  select(pie_size, p.value) %>% 
  mutate(pie_size = as.character(pie_size))


# merge
T1_pie <- T1_pie %>% left_join(T1_pie_test, by = "pie_size")


## third part: by pie size and offer

T1_offer <- df %>% 
  group_by(reaction, pie_size, offer) %>% 
  summarise(time = mean(reaction_time), 
            sd = sd(reaction_time),
            N=length(reaction_time)) %>% 
  mutate(pie_size = as.character(pie_size), offer = as.character(offer)) %>% 
  select(pie_size, offer, everything()) %>% 
  arrange(pie_size, offer)

# test
T1_offer_test <- df %>% 
  filter(reaction != "Error") %>% 
  mutate(accept = reaction == "Accept") %>% 
  group_by(pie_size, offer) %>% 
  group_modify(~tidy(wilcox.test(.$reaction_time~.$accept, paired=F))) %>% 
  select(pie_size, offer, p.value) %>% 
  mutate(pie_size = as.character(pie_size), offer = as.character(offer))


# merge
T1_offer <- T1_offer %>% left_join(T1_offer_test, by = c("pie_size","offer"))


## merging the whole table
Table1 <- bind_rows(T1_all, T1_pie, T1_offer) %>% 
  mutate(across(time:p.value, round, 2))

## exporting to csv
Table1 %>% write_csv("Tables/Table_1.csv")


# Table 2 -- response time by behavioral type

# overall
T2_overall <- df %>%
  group_by(subject_type)%>%
  summarise(time = mean(reaction_time))

# tests
T2_test <- df %>%
  group_by(subject_type) %>% 
  mutate(accept = reaction == "Accept") %>% 
  do(tidy(wilcox.test(.$reaction_time~.$accept, paired=F))) %>% 
  select(subject_type, p.value)

# mean and sd + merge

Table2 <-  df %>%
  group_by(subject_type, reaction)%>%
  filter(reaction != "Error") %>% 
  summarise(time = mean(reaction_time), sd = sd(reaction_time), N = n()) %>% 
  unite(indicator, N, time, sd, sep = "_") %>% 
  spread(reaction, indicator) %>% 
  separate(Accept, into = c("a.N", "a.mean", "a.sd"), sep = "_") %>% 
  separate(Reject, into = c("r.N", "r.mean", "r.sd"), sep = "_")%>% 
  left_join(T2_overall, by = "subject_type") %>% 
  select(subject_type, overall = time, everything()) %>% 
  left_join(T2_test, by = "subject_type") 

# save table
Table2 %>% write_csv("Tables/Table_2.csv")


# cleaning
rm(T1_all, T1_all_test, T1_offer, T1_offer_test, T1_pie, T1_pie_test, T2_overall, T2_test, Table1, Table2)


## additional tests: opportunistic take less than all other types

# number of acceptances and rejections by type
df %>% 
  group_by(reaction, subject_type) %>% 
  tally() %>% 
  spread(reaction, n)

# opportunistic vs. monotonic
wilcox.test(df$reaction_time[df$reaction == "Accept" & df$subject_type == "Opportunistic"],
            df$reaction_time[df$reaction == "Accept" & df$subject_type == "Monotonic"]) %>% 
  tidy()

# opportunistic vs. fairness minded
wilcox.test(df$reaction_time[df$reaction == "Accept" & df$subject_type == "Opportunistic"],
            df$reaction_time[df$reaction == "Accept" & df$subject_type == "Fairness minded"]) %>% 
  tidy()

# opportunistic vs. residual
wilcox.test(df$reaction_time[df$reaction == "Accept" & df$subject_type == "Opportunistic"],
            df$reaction_time[df$reaction == "Accept" & df$subject_type == "Residual"]) %>% 
  tidy()
  
