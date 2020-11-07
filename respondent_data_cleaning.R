# cleaning the respondent data

# software collected extra stimuli while adjusting machine for some subjects. deleting those
df <- df %>% 
  filter(X1 < 140)

# dropping unused variables
df <- df %>% 
  select(-X1, -Uhrzeit, -Angebotskategorie)

# renaming 
df <- df %>% 
  select(-Gebotindex, 
         -Geber) %>% 
  rename(subject_ID = subjectID, 
         part = Teil,
         choice_N = Durchgang,
         pie_size = Ausgangswert,         
         offer = Anteil, 
         reaction = Reaktion,
         reaction_time = Reaktionszeit
         )

# correcting choice_N 
df <- df %>%
  group_by(subject_ID) %>%
  mutate(choice_N = row_number())

# assign subjects to types
df <- df %>% 
  mutate(subject_type2 = case_when(subject_ID==2 | subject_ID==12 | subject_ID==13 | subject_ID==20 ~ "Opportunistic",
                                  subject_ID==1 | subject_ID==11 | subject_ID==15 ~ "Residual",
                                  subject_ID==8 | subject_ID==9 | subject_ID==21 | subject_ID==22 ~ "Fairness minded",
                                  TRUE ~ "Monotonic"))

# translate reaction types
df <- df %>% 
  mutate(reaction = case_when(reaction == "Angenommen" ~ "Accept",
                              reaction == "Abgelehnt"  ~ "Reject",
                              reaction == "Fehler"     ~ "Error"))

  