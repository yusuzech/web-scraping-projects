threads <- list.files("data/thread/")
current_time <- with_tz(now())
current_year <- year(current_time)
current_month <- month(current_time)
current_day <- day(current_time)
merged_table <- tibble()
for(i in 1 : length(threads)){
    table <- suppressMessages(read_csv(str_c("data/thread/",threads[i]),col_types = list("post_id" = "c",
                                                                                         "parent_thread" = "c",
                                                                                         "post_content" = "c")))
    merged_table <- bind_rows(merged_table,table)
    if(i %in% round(length(threads)*seq(0,1,0.1))){
        cat(round(i/length(threads)*100),"%","completed\t","Beijing time:",as.character(now()),"\n")
    }
}
write.csv(merged_table,file = 
              str_c("data/datatable/","thread_data_",current_year,"-",current_month,"-",current_day,".csv"),
          row.names = FALSE,fileEncoding = "UTF-8")

