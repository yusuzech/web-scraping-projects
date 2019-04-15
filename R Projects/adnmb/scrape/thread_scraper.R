#build thread scraper to scrape each thread
thread_scraper <- function(thread_id,start_page = 1L,thread_url_pre = "http://adnmb1.com/t/"){
    source("scrape/parse_functions.R")
    thread_url_pager = "?page="
    post_id_css <- ".h-threads-info-id"
    post_uid_css <- ".h-threads-info-uid"
    post_time_css <- ".h-threads-info-createdat"
    post_content_css <- ".h-threads-content"
    page_menu_css <- ".uk-pagination"
    #What's the max page?
    #trycatch mysession
    my_session <- html_session(str_c(thread_url_pre,thread_id))
    page_menu_node <- my_session %>%
        html_node(".uk-pagination") %>%
        html_nodes("li")
    page_menu_text <-page_menu_node %>% html_text()
    #is there only one page? css selector is different in this case
    condition <- suppressWarnings(max(as.integer(page_menu_text),na.rm = TRUE) == 1)
    if(!condition){
        max_page <- page_menu_node %>%
            html_nodes("a") %>%
            html_attr("href") %>%
            str_extract("(?<=\\?page=).*") %>%
            as.integer() %>% 
            max()
    } else {
        #if there is only one page, css selector is different
        max_page = 1
    }
    #return format:
    #post_id,post_uid,post_time,post_content,post_page
    tb_thread <- tibble()
    while(start_page <= max_page){
        thread_url <- str_c(thread_url_pre,thread_id,thread_url_pager,start_page)
        thread_session <- html_session(thread_url)
        
        post_ids <- thread_session %>% html_nodes(post_id_css) %>% html_text() %>% parse_id()
        post_uids <- thread_session %>% html_nodes(post_uid_css) %>% html_text() %>% parse_uid()
        post_times <- thread_session %>% html_nodes(post_time_css) %>% html_text() %>% parse_post_time()
        post_contents <- thread_session %>% html_nodes(post_content_css) %>% html_text() %>% parse_content()
        tb_current_page <- bind_cols(post_id = post_ids,
                                     post_uid = post_uids,
                                     post_time = post_times,
                                     post_content = post_contents,
                                     post_page = rep(start_page,length(post_ids)),
                                     parent_thread = rep(as.character(thread_id),length(post_ids)))
        start_page <- start_page + 1L
        tb_thread <- bind_rows(tb_thread,tb_current_page)
    }
    return(tb_thread)
}
