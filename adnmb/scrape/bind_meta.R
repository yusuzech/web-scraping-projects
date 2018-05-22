metas <- list.files("data/meta/")
current_time <- with_tz(now())
current_year <- year(current_time)
current_month <- month(current_time)
current_day <- day(current_time)
merged_meta <- tibble()
for(i in 1 : length(metas)){
    table <- suppressMessages(read_csv(str_c("data/meta/",metas[i]),col_types = list("header_id" = "c",
                                                                                       "last_reply_id" = "c")))
    merged_meta <- bind_rows(merged_meta,table)
    if(i %in% round(length(metas)*seq(0,1,0.1))){
        cat(round(i/length(metas)*100),"%","completed\t","Beijing time:",as.character(now()),"\n")
    }
}
#update meta
merged_meta <- merged_meta %>%
    distinct(header_id,last_reply_id,.keep_all = TRUE) %>%
    group_by(header_id) %>%
    arrange(last_reply_post_time) %>%
    dplyr::filter(row_number() == n()) %>%
    ungroup()
write.csv(merged_meta,file = 
              str_c("data/merged_meta/","merged_meta_",current_year,"-",current_month,"-",current_day,".csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

