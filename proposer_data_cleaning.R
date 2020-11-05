#renaming
df <- df %>% 
  rename("largepie" = Role,
         "pie" = endowment,
         "offer" = choice,
         "belief" = Belief,
         "faculty" = Studium,
         "semester" = Semesterzahl,
         "age" = Alter,
         "female" = Geschlecht,
         "session" = Session,
         "trust"  = Trustindex)

# factors
df <- df %>% 
  mutate(pie = as_factor(pie),
         largepie = as_factor(largepie),
         belief = as_factor(belief),
         belief = fct_recode(belief, "accept" = "0","reject" = "1"),
         offer_num = offer,
         offer = as_factor(offer),
         offer = fct_recode(offer, "Offer = 1" = "1", "Offer = 3" = "3", "Offer = 5" = "5"),
         female = as_factor(female),
         female = fct_recode(female, "male" = "0", "female" = "1"),
         pie = fct_recode(pie, "pie size 11" = "11", "pie size 19" = "19")
  )


#other changes
df <- df %>% 
  mutate(SVO = SVO*180/pi) %>% 
  mutate(SVO_cat = cut(SVO, c(-1000,-12.04,22.45,57.15,1000 ))) %>% 
  mutate(SVO_cat = fct_recode(SVO_cat,
                              "competitive" = "(-1e+03,-12]",
                              "individualist" = "(-12,22.4]",
                              "prosocial" = "(22.4,57.1]",
                              "altruist" = "(57.1,1e+03]"))