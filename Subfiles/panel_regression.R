
# focus on data for 1-€ offers
regdf <- df %>% 
  filter(offer == "1")

# the idea is to regress the reaction time on the reaction type

# not so easy: the point is that the higher the acceptance RATE (that is an average) 
# the lower the reaction time for the most used action
# ie: the more you accept, the faster you do so and the more times it takes you to reject
# conversely, the more you reject, the more time it takes you to accept