## -----------------------------------------
## load packages
## -----------------------------------------

library(here)
library(tidyverse)
library(gsubfn)
library(beepr)

?replace()

## -----------------------------------------
## load, clean data
## -----------------------------------------

# load CSV
df <- read_csv(here::here("sync-async-dataset.csv"))

# move non-LIWC variables from first row to row headers
names(df)[1:91] <- df[1,1:91] 

# delete now-useless first row
df <- df[-1,]

View(df)

## -----------------------------------------
## create hashtag and URL counts 
## -----------------------------------------

# these columns depend on the text column, so we'll have to create them here

hashtag_pattern <- "#([0-9]|[a-zA-Z])+"
link_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"

df <- mutate(df, 
            hashtags_count = str_count(text, hashtag_pattern),
            urls_count = str_count(text, link_pattern))

## -----------------------------------------
## anonymize names
## -----------------------------------------

mentionsList <- str_extract_all(df$mentions_screen_name[!is.na(df$mentions_screen_name)], "[^ ]+") %>% 
                unlist() %>%
                unique()

name_list <- unique(c(df$screen_name, mentionsList))
anonymous_name_list <- paste0("username_",1:length(name_list))

# length(name_list)
# length(anonymous_name_list)

for(i in 1:length(name_list)){
    df$screen_name <- str_replace(df$screen_name, paste0("\\b",name_list[i],"\\b"), anonymous_name_list[i])
    df$mentions_screen_name <- str_replace(df$mentions_screen_name, paste0("\\b",name_list[i],"\\b"), anonymous_name_list[i])
    print(i)
}

beepr::beep(8)

View(df)
View(df_old)

## -----------------------------------------
## anonymize status_ids
## -----------------------------------------

status_list <- unique(c(df$status_id, df$reply_to_status_id[!is.na(df$reply_to_status_id)]))
anonymous_status_list <- paste0("status_",1:length(status_list))


for(i in 1:length(status_list)){
    df$status_id <- str_replace(df$status_id, paste0("\\b",status_list[i],"\\b"), anonymous_status_list[i])
    df$reply_to_status_id <- str_replace(df$reply_to_status_id, paste0("\\b",status_list[i],"\\b"), anonymous_status_list[i])
    print(i)
}

write_csv(df, "backup_df.csv")

## -----------------------------------------
## delete identifiable information
## -----------------------------------------

df_anonymous <- df[,c(2:3,8,11:19,29, 90:186)]

colnames(df)

View(df_anonymous)

write_csv(df_anonymous, "anonymized-dataset.csv")
