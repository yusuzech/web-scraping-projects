#use output from thread metadata
meta_filenames <- list.files("data/meta")
meta_time <- str_extract(meta_filenames,"(?<=data_).+(?=.csv)")
last_meta_file <- meta_filenames[match(max(meta_time),meta_time)]
last_meta <- read_csv(str_c("data/meta/",last_meta_file))
meta_time_hms <- ymd_hms(str_c(meta_time," 12:00:00"))

#thread--------
source("scrape/thread_scraper.R")
thread_files <- list.files("data/thread")
recorded_header_ids = str_sub(thread_files,end = -5) %>% as.numeric()

thread_url <- "http://adnmb1.com/t/"
thread_pager <-"?page="
for (i in 1:nrow(last_meta)) {
    source("scrape/add_or_update.R",local = TRUE)
    cat("id:",last_meta[[i,"header_id"]],"\t","thread",i,"in",nrow(last_meta),"completed\t",
        update_comment,"\t","Beijing time:",as.character(now()),"\n")
}
