#if thread is in, update or keep unchanged
source("functions/retry_n.R") #import retry function
if(last_meta[[i,"header_id"]] %in% recorded_header_ids){
    #get the same thread and compare
    recorded_thread <- suppressMessages(read_csv(str_c("data/thread/",last_meta[[i,"header_id"]],".csv"),locale = locale("zh"),
                                                 col_types = list("post_id"="c","parent_thread"="c")))
    #if last reply remains to be NA, then we don't need to update
    if(is.na(last_meta[[i,"last_reply_post_time"]]))
    {
        #do nothing
        update_comment <- "No new content, no need to update"
    } else if (last_meta[[i,"last_reply_id"]] == 
               recorded_thread[[nrow(recorded_thread),"post_id"]]){
        #to improve
        #can use post id to identify since id is unique
        #if the last post time are the same, keep unchanged
        update_comment <- "No new content, no need to update"
    } else {
        #if there are new post, then update
        update_content <- retry_n(thread_scraper(last_meta[[i,"header_id"]],
                                         start_page = recorded_thread[[nrow(recorded_thread),"post_page"]],
                                         thread_url_pre = thread_url),syssleep = 5,failing_return = tibble())
        if(nrow(update_content)==0){
            print("thread deleted, no update.")
            next()
        }
        thread_content <- bind_rows(recorded_thread,update_content) %>%
            distinct(post_id,.keep_all = TRUE)
        #overwrite
        write.csv(thread_content,file = str_c("data/thread/",last_meta[[i,"header_id"]],".csv"),row.names = FALSE,fileEncoding = "UTF-8")
        update_comment <- "New content in thread updated"
        Sys.sleep(sample(0:1,1))
    }
} else {
    #add new
    if(is.na(last_meta[[i,"last_reply_post_time"]])){
        write.csv(thread_content,file = str_c("data/thread/",last_meta[[i,"header_id"]],".csv"),row.names = FALSE,fileEncoding = "UTF-8")
        update_comment <- "New thread added"
        Sys.sleep(sample(0:1,1))
    } else {
        time_constraint <- ((last_meta[[i,"last_reply_post_time"]] >= meta_time_hms - hours(24*32)) &
                                (last_meta[[i,"last_reply_post_time"]] <= meta_time_hms + hours(24*2)))
        if(time_constraint){
            thread_content <-retry_n(thread_scraper(last_meta[[i,"header_id"]],thread_url_pre = thread_url),
                                     syssleep = 5,failing_return = tibble())
            #if table is empty(thread deleted), skip
            if(nrow(thread_content)==0){
                print("thread deleted")
                next()
            } else {
                write.csv(thread_content,file = str_c("data/thread/",last_meta[[i,"header_id"]],".csv"),row.names = FALSE,fileEncoding = "UTF-8")
                update_comment <- "New thread added"
                Sys.sleep(sample(0:1,1))
            }
        }
    }
}