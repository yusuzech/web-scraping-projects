parse_id <- function(x){x %>% str_sub(start = 4) %>% as.character()}
parse_uid <- function(x){x %>% str_sub(start = 4)}
parse_post_time <- function(x){x %>%
        str_replace(pattern = "\\(.\\)",replacement = " ") %>%
        ymd_hms(tz = "Asia/Shanghai")}
parse_content <- function(x){x %>% str_trim()}