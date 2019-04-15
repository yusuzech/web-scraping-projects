db_remove_duplicate <- function()

old_ver <- dbReadTable(con,table_name)
new_ver <- old_ver %>%
    bind_rows(x) %>%
    group_by(UQ(rlang::sym(table_id))) %>%
    dplyr::filter(record_date == as.character(max(lubridate::ymd(record_date)))) %>%
    distinct(UQ(rlang::sym(table_id)),.keep_all = T) %>%
    ungroup()