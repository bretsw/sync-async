library(brms)
m9a <- brm(Mentions ~ is_sync + (1|screen_name), family = "poisson", data = prepped_data, chains = 4, cores = 4) # warning
