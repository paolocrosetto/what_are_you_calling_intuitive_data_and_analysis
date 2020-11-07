# computing the share of estimated rejections

df %>% 
  group_by(pie, offer, belief) %>% 
  tally() %>% 
  mutate(N = sum(n),
         share = 100*n/N) %>% 
  filter(belief == "reject") %>% 
  select(pie, offer, share) -> prop_expec_shares

prop_expec_shares