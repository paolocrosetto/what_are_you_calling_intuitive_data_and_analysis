### Table 1  -- response time 

# changing order of response factor for better reporting
df <- df %>% 
  mutate(reaction = as.factor(reaction),
         reaction = fct_relevel(reaction, "Reject", "Accept"))

a## first part: all observations

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
Table1 %>% write_csv("Tables/Table1.csv")

library(xtable)

Table1 %>% xtable()

# Table 2 -- response time by behavioral type

