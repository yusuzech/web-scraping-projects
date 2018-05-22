library(tidyverse)
library(RSQLite)

source("zhihu/get_topic.R")
source("zhihu/get_user_info_json.R")
source("zhihu/get_following.R")
source("zhihu/write_2_db.R")
source("zhihu/loop_user_info.R")
source("zhihu/db_remove_duplicate.R")


topic_bitcoin<- get_topic(19600228,scroll_down_time = 50)
topic_bitcoin <- topic_bitcoin %>% 
    mutate(record_date = as.character(record_date))
#write to db
write_2_db(topic_bitcoin,db_path = "zhihu/data/zhihu.db","topic_bitcoin")

#get user rank -------
user_rank <- dbReadTable(con,"topic_bitcoin") %>%
    dplyr::filter(content_type=="answer",
                  !is.na(user_id)) %>%
    group_by(user_id) %>%
    summarise(total_upvote =sum(upvote)) %>%
    arrange(desc(total_upvote))

#get proxy table ------
my_proxy <- read_csv("private/userpackagesIppacks.csv")
con <- dbConnect(SQLite(),"zhihu/data/zhihu.db")
#get user info,retry n times to get uncompleted items --------
complete_flag <- F
tried <- 1
user_info_list <- user_rank$user_id
while(tried <= 4 & complete_flag == F){
    user_info_out_put <- loop_user_info(user_list = user_info_list,my_proxy = my_proxy)
    #no logical class in sqlite, convert all logical to integer -----------
    tb_2_db <- user_info_out_put$complete %>%
        mutate_if(~is.logical(.x),~as.integer(.x))
    write_2_db(x = tb_2_db,db_path = "zhihu/data/zhihu.db",table_name = "user_detail_bitcoin")
    if(is.null(user_info_out_put$uncomplete)){
        complete_flag == T
    } else {
        user_info_list<-user_info_out_put$uncomplete
        text_out <- glue::glue("times tried: {tried} ; {glue_length} items not completed:\n{glue_list}\n",
                               glue_length = length(user_info_list),
                               glue_list =str_c(user_info_list,collapse = ","))
        cat(text_out)
        tried <- tried + 1
    }
}
#remove duplications -------------
db_remove_duplicate(con,"user_detail_bitcoin","urlToken")

# #
# user_info_all <- tibble()
# uncomplete_user_info <- c()
# for(user in user_rank$user_id){
#     #scrape user -------
#     user_info <- get_user_info_json(user,my_proxy = my_proxy)
#     if(is.null(user_info)){
#         print("NULL returned")
#         uncomplete_user_info <- c(uncomplete_user_info,user)
#         next()
#     }
#     user_info <- user_info %>% 
#         mutate(record_date = as.character(Sys.Date()))
#     user_info_all <- bind_rows(user_info_all,user_info)
#     #print ---------
#     cat(match(user,user_rank$user_id)," in ", length(user_rank$user_id),"completed.\n")
# }
# 
# write_2_db(x = user_info_all,table_id = "urlToken",db_path = "zhihu/data/zhihu.db",table_name = "user_detail_bitcoin")

#get following table ---------------
con <- dbConnect(SQLite(),"zhihu/data/zhihu.db")
user_detail_table <- dbReadTable(con,"user_detail_bitcoin")
user_list <- user_detail_table %>% 
    group_by(urlToken) %>% 
    summarise(total_vote = sum(voteupCount)) %>%
    arrange(desc(total_vote)) %>%
    pull(urlToken) 

for(user in user_list){
    text_start <- glue::glue("{user_count} of {length_total} users: {user} start:-----------------",
                             user_count = match(user,user_list),
                             length_total=length(user_list))
    cat(text_start,"\n")
    current_follow_tb <- get_following(user,my_proxy = my_proxy) 
    if(is.null(current_follow_tb)){
        next()
    }
    current_follow_tb <- current_follow_tb %>% 
        mutate(record_date = as.character(Sys.Date())) %>%
        mutate_if(is.logical,as.integer)
    follower_following <- current_follow_tb %>%
        mutate(following=urlToken) %>%
        mutate(follower=user) %>%
        select(follower,following)
    write_2_db(x = follower_following,db_path = "zhihu/data/zhihu.db",table_name="follower_following_bitcoin")
    write_2_db(x = current_follow_tb,db_path = "zhihu/data/zhihu.db",table_name = "user_following_bitcoin")
    
    text_end <- glue::glue("{user_count} of {length_total} users: {user} end:---------------------",
                             user_count = match(user,user_list),
                             length_total=length(user_list))
    cat(text_end,"\n")
}

#remove duplications ---------
db_remove_duplicate(con,"topic_bitcoin","thread_id")
db_remove_duplicate(con,"user_following_bitcoin","urlToken")


#continue the process above with more data -----------------------
#get following--------------
con <- dbConnect(SQLite(),"zhihu/data/zhihu.db")
user_following1 <- dbReadTable(con,"user_following_bitcoin")
user_list1 <- user_following1 %>% 
    group_by(urlToken) %>% 
    summarise(total_vote = sum(followerCount)) %>%
    arrange(desc(total_vote)) %>%
    pull(urlToken)
#don't repeat --------
user_list1 <- user_list1[!(user_list1 %in% user_list)]

for(user in user_list1[223:length(223)]){
    text_start <- glue::glue("{user_count} of {length_total} users: {user} start:-----------------",
                             user_count = match(user,user_list1),
                             length_total=length(user_list1))
    cat(text_start,"\n")
    current_follow_tb <- get_following(user,my_proxy = my_proxy) 
    if(is.null(current_follow_tb)){
        next()
    }
    current_follow_tb <- current_follow_tb %>% 
        mutate(record_date = as.character(Sys.Date())) %>%
        mutate_if(is.logical,as.integer)
    follower_following <- current_follow_tb %>%
        mutate(following=urlToken) %>%
        mutate(follower=user) %>%
        select(follower,following)
    write_2_db(x = follower_following,db_path = "zhihu/data/zhihu.db",table_name="follower_following_bitcoin")
    write_2_db(x = current_follow_tb,db_path = "zhihu/data/zhihu.db",table_name = "user_following_bitcoin")
    
    text_end <- glue::glue("{user_count} of {length_total} users: {user} end:---------------------",
                           user_count = match(user,user_list1),
                           length_total=length(user_list1))
    cat(text_end,"\n")
}
db_remove_duplicate(con,"user_following_bitcoin","urlToken")
