db_remove_duplicate <- function(con,table_name,table_id){
    #using record date as reference(default)
    df <- dbReadTable(con,table_name)
    TEMP_OUT <<- df
    cat("file in database saved to TEMP_OUT in global environment in case data is lost\n")
    out <- df %>%
        group_by(UQ(rlang::sym(table_id))) %>%
        dplyr::filter(record_date == as.character(max(lubridate::ymd(record_date)))) %>%
        distinct(UQ(rlang::sym(table_id)),.keep_all = T) %>%
        ungroup()
    dbWriteTable(con,table_name,out,overwrite=T)
}

