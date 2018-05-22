#use latest user data for analysis ------
#thread data
filenames <- list.files("data/datatable/")
file_time <- str_extract(filenames,"(?<=data_).+(?=.csv)")
last_file <- filenames[match(max(file_time),file_time)]
dataset_thread <- read_csv(str_c("data/datatable/",last_file),col_types = list("post_id" = "c",
                                                                        "parent_thread" = "c"))
last_thread_date <- ymd(file_time)
#thread metadata ------------------
filenames <- list.files("data/meta/")
file_time <- str_extract(filenames,"(?<=data_).+(?=.csv)")
last_file <- filenames[match(max(file_time),file_time)]
dataset_meta <- read_csv(str_c("data/meta/",last_file),col_types = list("header_id" = "c",
                                                                        "last_reply_id" = "c"))
meta_add_adte <- dataset_meta %>%
    dplyr::filter((header_post_time >= last_thread_date - months(1)) & (header_post_time <= last_thread_date)) %>%
    mutate(day = day(header_post_time),
           month = as.integer(month(header_post_time)),
           year = year(header_post_time),
           weekdays = weekdays(header_post_time,abbreviate = T),
           week = as.integer(week(header_post_time)),
           minute = minute(header_post_time),
           hour = hour(header_post_time),
           date = ymd(str_c(year,"-",month,"-",day)))

last_thread_date <- ymd(file_time)

# merge tables ---------
dataset_thread <- dataset_thread %>% 
    left_join(dataset_meta %>% select(header_id,channel_name),by = c("parent_thread"="header_id"))

 #active users by time for last month-------------
dataset_add_dates <- dataset_thread %>%
    dplyr::filter((post_time >= last_thread_date - months(1)) & (post_time <= last_thread_date)) %>%
    mutate(day = day(post_time),
           month = as.integer(month(post_time)),
           year = year(post_time),
           weekdays = weekdays(post_time,abbreviate = T),
           week = as.integer(week(post_time)),
           minute = minute(post_time),
           hour = hour(post_time),
           date = ymd(str_c(year,"-",month,"-",day)))
#server downtime---------
time_intervals <- interval(dplyr::lag(sort(dataset_add_dates$post_time)),sort(dataset_add_dates$post_time),tzone = "Asia/Shanghai")
time_span <- time_intervals[2:length(time_intervals)]/hours(1)
down_intervals <- time_intervals[which(time_span > 3)+1]
#down hours
down_times <- down_intervals/hours(1)
#down_time_specific used for other calculations
down_dates <- attributes(down_intervals)$start + hours(1:round(down_times))
source("analysis/bind_dates_in_list.R")
all_downs <- bind_dates_in_list(map2(attributes(down_intervals)$start,round(down_times),~ .x + hours(1:.y)))
downs_table <- tibble(down_pox = all_downs,
                      year = year(down_pox),
                      month = as.integer(month(down_pox)),
                      week = as.integer(week(down_pox)),
                      day = day(down_pox),
                      hour = hour(down_pox),
                      minute = minute(down_pox),
                      weekdays = weekdays(down_pox))

#totals -----------
#report period
#total newthreads
ttl0 <- nrow(meta_add_adte)
#total new posts
ttl1 <- nrow(dataset_add_dates)
#total active users(count by unique post_uid)
ttl2 <- length(unique(dataset_add_dates$post_uid))
#post per active user
ttl3 <- length(unique(dataset_add_dates$post_id))/length(unique(dataset_add_dates$post_uid))
#Down time
ttl4 <- down_intervals
#total down length in hours
ttl5 <- sum(round(down_intervals/hours(1)))
rm(time_intervals,time_span,down_intervals,down_times,down_dates,all_downs)

#active days(date filter not set correctly yet) -------
dataset_add_dates %>%
    group_by(date) %>%
    count() %>%
    ungroup() %>%
    ggplot(aes(x = date,y = n)) +
    geom_col(fill = "skyblue3") +
    labs(x = "日期",y = "当日回复",title = "每日回复量")  +
    theme_light()
#active weekday--------
dataset_add_dates %>%
    group_by(weekdays) %>%
    mutate(weekdays_on = n_distinct(week)) %>%
    summarise(avg_post = round(n()/first(weekdays_on))) %>%
    ungroup() %>%
    mutate(weekdays = factor(weekdays,levels = c("周一","周二","周三","周四","周五","周六","周日"))) %>%
    ggplot(aes(x = weekdays,y = avg_post)) +
    geom_col(fill = "skyblue3") + 
    theme_light() +
    labs(x = "", y = "日均回复")

#每小时平均回复
dataset_add_dates %>%
    group_by(hour) %>%
    mutate(hours_on = n_distinct(day)) %>%
    summarise(avg_post = round(n()/first(hours_on))) %>%
    ungroup() %>%
    ggplot(aes(x = hour,y = avg_post)) +
    geom_col(fill = "skyblue3") + 
    theme_light() +
    labs(x = "", y = "每小时平均回复")

