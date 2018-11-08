
# For plot

df_ss$date_r <- floor_date(df_ss$date, "day")

to_plot <- df_ss %>% count(date_r, is_sync)
to_plot <- as.data.frame(to_plot)
to_plot <- tidyr::complete(to_plot, date_r, is_sync, fill = list(n = 0))
to_plot$during_sync_chat <- as.factor(to_plot$is_sync)
levels(to_plot$during_sync_chat) <- c('Not During a Chat (Asynchronous)',
                                      'During a Chat (Synchronous)')

to_plot <- filter(to_plot,
                  date_r != ymd("2015-08-31"))

to_plot$date_r <- as_date(to_plot$date_r)

ggplot(to_plot, aes(x = date_r, y = n,
                    group = during_sync_chat,
                    color = during_sync_chat)) +
    geom_point(size = 1.25) +
    geom_line(size = .7) +
    scale_color_brewer("", type = "qual", palette = 6) +
    xlab(NULL) +
    ylab("Number of Tweets") +
    scale_x_date(breaks = seq(as.Date("2015-09-01", tz = "America/Detroit"),
                              as.Date("2016-08-31", tz = "America/Detroit"),
                              by = "2 months"),
                 date_labels = "%b %g") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    hrbrthemes::theme_ipsum(base_size = 12) +
    theme(legend.position = "bottom")

# Tweeters

df_ss %>% 
    group_by(is_sync) %>% 
    summarize(unique_tweeters = length(unique(tolower(screen_name))))

df_ss %>% 
    filter(type == "ORIG") %>% 
    count(is_sync) %>% 
    group_by(is_sync) %>% 
    summarize(mean_n = mean(n))

df_ss %>% 
    filter(type == "ORIG") %>% 
    count(is_sync, screen_name) %>% 
    rename(number_of_orig_tweets = n) %>%  
    t_test(number_of_orig_tweets, is_sync)

df_ss %>% 
    count(is_sync, screen_name, type) %>% 
    complete(is_sync, screen_name, type, fill = list(n = 0)) %>% 
    filter(type == "ORIG") %>% 
    rename(number_of_orig_tweets = n) %>%  
    t_test(number_of_orig_tweets, is_sync)

# Original tweets

df_ss %>% 
    filter(type == "ORIG") %>% 
    count(is_sync)

# T-test for original tweets

df_ss %>% 
    filter(type == "ORIG") %>% 
    count(is_sync, screen_name) %>% 
    rename(the_n = n) %>% 
    t_test(the_n, is_sync)

# Interactions

df_orig <- df_ss %>% filter(type == "ORIG")

# group_by(is_sync, type) %>% 
select(is_sync, 
       favorites = scraped_num_favorites, 
       retweets = retweet_count, 
       replies = scraped_num_replies, 
       mentions = num_non_reply_mentions, 
       hashtag = num_hashtags) %>% 
    group_by(is_sync) %>% 
    summarize_all(mean) %>% 
    gather(key, val, -is_sync) %>% 
    mutate(is_sync = as.factor(is_sync)) %>% 
    ggplot(aes(x = reorder(key, val), y = val, fill = is_sync)) +
    geom_col(position = "dodge") + 
    coord_flip() +
    hrbrthemes::theme_ipsum()

# T-test for favs

df_ss %>% 
    filter(type == "ORIG") %>% 
    t_test(favorite_count, is_sync)

# T-test for retweets

df_ss %>% 
    filter(type == "ORIG") %>% 
    t_test(retweet_count, is_sync)

# T-test for replies

df_ss %>% 
    filter(type == "ORIG") %>% 
    t_test(scraped_num_replies, is_sync)

# T-test for mentions

df_ss %>% 
    filter(type == "ORIG") %>% 
    t_test(num_non_reply_mentions, is_sync)

# chi-sq for quote tweets

df_ss %>% 
    filter(type == "QUOTE") %>% 
    count(is_sync)

chisq.test(c(8468, 1465))

# T-test for hashtags

df_ss %>% 
    filter(type == "ORIG") %>% 
    summarize(mean_num_hashtags = mean(num_hashtags))

df_ss %>% 
    filter(type == "ORIG") %>% 
    t_test(num_hashtags, is_sync)

# T-test for URLS

df_ss %>% 
    filter(type == "ORIG") %>% 
    summarize(mean_urls_hashtags = mean(num_urls))

df_ss %>% 
    filter(type == "ORIG") %>% 
    t_test(num_urls, is_sync)

chisq.test(c(8468, 1465))

# RQ 1
# Total tweets
chisq.test(c(70576, 19367))
chisq.test(c(28,302, 8989))

# Quote

df_ss %>% 
    filter(type == "QUOTE") %>% 
    count(is_sync) %>% 
    mutate(n = n / sum(n))

df_ss %>% 
    filter(type == "QUOTE") %>% 
    count(is_sync) %>% 
    mutate(n = n / c(70576, 19367))

# LIWC

liwc <- read_csv("~/Dropbox/1_Research/miched_new/snyc_async_tweets_liwc.csv")
liwc <- rename(liwc, tweet_link = `Source (A)`)
liwc_df <- left_join(liwc, df_ss)

# affect

mean(liwc_df$affect)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(affect, is_sync)

# social

mean(liwc_df$social)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(social, is_sync)

# cogproc

mean(liwc_df$cogproc)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(cogproc, is_sync)

# percept

mean(liwc_df$percept)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(percept, is_sync)

# bio

mean(liwc_df$bio)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(bio, is_sync)

# drives

mean(liwc_df$drives)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(drives, is_sync)

# time orientation

mean(liwc_df$time)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(time, is_sync)

# relativity

mean(liwc_df$relativ)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(relativ, is_sync)

# personal concerns - work

mean(liwc_df$work)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(work, is_sync)

# informal

mean(liwc_df$informal)

liwc_df %>%
    filter(type == "ORIG") %>% 
    t_test(informal, is_sync)

# Plot for interactions

df_ss %>% 
    select(is_sync, 
           favorite_count,
           retweet_count, 
           scraped_num_replies,
           num_non_reply_mentions) %>% 
    rename(Likes = favorite_count,
           Retweets = retweet_count,
           Replies = scraped_num_replies,
           Mentions = num_non_reply_mentions) %>% 
    group_by(is_sync) %>% 
    summarize_all(funs(mean, sd, n())) %>% 
    gather(key, val, -is_sync) %>% 
    separate(key, c("var", "stat")) %>% 
    spread(stat, val) %>% 
    mutate(se = sd / sqrt(n - 1)) %>% 
    mutate(is_sync = factor(is_sync, labels = c("Asynchronous", "Synchronous"))) %>% 
    ggplot(aes(x = reorder(var, mean), y = mean, fill = is_sync)) +
    geom_col(position = "dodge") +
    geom_errorbar(aes(ymin = mean - se, 
                      ymax = mean + se),
                  position = position_dodge()) +
    viridis::scale_fill_viridis("", discrete = T, option = "D") +
    coord_flip() +
    hrbrthemes::theme_ipsum(base_size = 12) +
    theme(legend.position="top") +
    xlab(NULL) +
    ylab("Mean Per Tweet")

ggsave("interactions.png", width = 5.5, height = 6)

# Plot for portals

df_ss %>% 
    select(is_sync, 
           num_hashtags,
           num_urls) %>% 
    rename(Hashtags = num_hashtags,
           URLs = num_urls) %>% 
    group_by(is_sync) %>% 
    summarize_all(funs(mean, sd, n())) %>% 
    gather(key, val, -is_sync) %>% 
    separate(key, c("var", "stat")) %>% 
    spread(stat, val) %>% 
    mutate(se = sd / sqrt(n - 1)) %>% 
    mutate(is_sync = factor(is_sync, labels = c("Asynchronous", "Synchronous"))) %>% 
    ggplot(aes(x = reorder(var, mean), y = mean, fill = is_sync)) +
    geom_col(position = "dodge") +
    geom_errorbar(aes(ymin = mean - se, 
                      ymax = mean + se),
                  position = position_dodge()) +
    viridis::scale_fill_viridis("", discrete = T, option = "D") +
    coord_flip() +
    hrbrthemes::theme_ipsum(base_size = 10) +
    theme(legend.position="top") +
    xlab(NULL) +
    ylab("Mean Per Tweet")

ggsave("portals.png", width = 5, height = 4.35)

# Plot for content

liwc_df %>% 
    select(is_sync, 
           affect,
           social,
           cogproc,
           percept,
           bio,
           drives,
           time,
           work) %>% 
    rename(Affect = affect,
           Social = social,
           `Cognitive Processing` = cogproc,
           `Perceptual Processes` = percept,
           `Biological Processes` = bio,
           Drives = drives,
           `Time Orientation` = time,
           `Work-related Concerns` = work) %>% 
    filter(!is.na(is_sync)) %>% 
    group_by(is_sync) %>% 
    summarize_all(funs(mean, sd, n())) %>% 
    gather(key, val, -is_sync) %>% 
    separate(key, c("var", "stat"), sep = "\\_") %>% 
    spread(stat, val) %>% 
    mutate(se = sd / sqrt(n - 1)) %>% 
    mutate(is_sync = factor(is_sync, labels = c("Asynchronous", "Synchronous"))) %>% 
    ggplot(aes(x = reorder(var, mean), y = mean, fill = is_sync)) +
    geom_col(position = "dodge") +
    geom_errorbar(aes(ymin = mean - se, 
                      ymax = mean + se),
                  position = position_dodge()) +
    viridis::scale_fill_viridis("", discrete = T, option = "D") +
    coord_flip() +
    hrbrthemes::theme_ipsum(base_size = 14) +
    theme(legend.position="top") +
    xlab(NULL) +
    ylab("Mean Per Tweet")

ggsave("content.png", width = 6.75, height = 7.75)
