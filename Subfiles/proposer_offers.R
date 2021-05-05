# Table 
library(kableExtra)

Table1 <- df %>% 
  group_by(pie, offer, .drop = F) %>% 
  summarise(count = n()) %>% 
  spread(offer, count) 

Table1 %>% 
  write_csv("Tables/Table_1.csv")

Table1 %>% 
  kbl(booktabs = T, 
      format = "latex", 
      caption = "Distribution of offers faced by respondents", 
      label = "tab:offers", )

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
