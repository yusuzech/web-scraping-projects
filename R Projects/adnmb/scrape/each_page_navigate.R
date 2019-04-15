#each page navigate
#take url from "front_page_navigate"
#take thread within the recent month
#define global css values-------------
page_turner <- "?page="
#css for all nodes
major_node_css <- ".h-threads-list"
max_page_css <- ".uk-pagination :nth-last-child(2)"
page_index_css <- ".uk-pagination"
#for replies
each_node_css_css <- '[data-threads-id="insertid"]'
reply_box_css <- ".h-threads-item-replys"
id_css <- ".h-threads-info-id"
uid_css <- ".h-threads-info-uid"
post_time_css <- ".h-threads-info-createdat"
content_css <- ".h-threads-content"
#for headers, add ".h-threads-item-main" css
header_id_css <- ".h-threads-item-main .h-threads-info-id"
header_uid_css <- ".h-threads-item-main .h-threads-info-uid"
header_post_time_css <- ".h-threads-item-main .h-threads-info-createdat"
header_content_css <- ".h-threads-item-main .h-threads-content"
#loops -----------------
source("scrape/parse_functions.R")
#break condition using post time
job_time <- with_tz(now())
thread_meta_data <- tibble()
for(ssp in 1 : length(ss_url_excluded)){
    #channel
    channel_name <- names(ss_url_excluded[ssp])
    while(TRUE){
        current_url <- str_c(ss_url_excluded[ssp],page_turner,current_section_page)
        #navigate to new page
        my_session <- html_session(current_url)
        #check status
        if(status_code(my_session) != 200){
            #do something like wait or continue and return an error log
            cat("cannot reach that page")
        }
        #content of each page,header metadata -------------
        thread_list <- my_session %>%
            html_node(major_node_css)
        header_id <- thread_list %>% 
            html_nodes(header_id_css) %>% 
            html_text() %>%
            parse_id()#thred header id
        header_uid <- thread_list %>% 
            html_nodes(header_uid_css) %>%
            html_text() %>%
            parse_uid()#uid
        header_post_time <- thread_list %>%
            html_nodes(header_post_time_css) %>%
            html_text() %>%
            parse_post_time()#post time
        header_content <- thread_list %>%
            html_nodes(header_content_css) %>%
            html_text() %>%
            parse_content()#header content of a thread
        tb_current_page <- tibble(channel_name = channel_name,
                                  header_id = header_id,
                                  header_uid = header_uid,
                                  header_post_time = header_post_time,
                                  header_content = header_content)
        #switch focus on each thread, get last reply info,used for checking updates-----------
        tb_reply_metadata <- tibble()
        for(i in 1 : nrow(tb_current_page)){
            thread_id <- tb_current_page[i,"header_id"]
            #switch focus to each thread(on main page)
            each_node_css <- each_node_css_css %>%
                str_replace(pattern = fixed("insertid"),replacement = tb_current_page[i,"header_id"])
            focused_thread <- thread_list %>% html_nodes(each_node_css)
            #find the last child of reply
            reply_node <- focused_thread %>%
                html_node(reply_box_css)
            #check if there is any reply and return results accordingly
            if(length(reply_node[[1]]) == 2){
                last_child_of_reply <- reply_node %>% 
                    html_node("div:last-child")
                last_reply_id <- last_child_of_reply %>% html_node(id_css) %>% html_text() %>% parse_id()
                last_reply_uid <- last_child_of_reply %>% html_node(uid_css) %>% html_text() %>% parse_uid()
                last_reply_post_time <- last_child_of_reply %>% html_node(post_time_css) %>% html_text() %>% parse_post_time()
                last_reply_content <- last_child_of_reply %>% html_node(content_css) %>% html_text() %>% parse_content()
                reply_metadata <- tibble(last_reply_id = last_reply_id,
                                         last_reply_uid = last_reply_uid,
                                         last_reply_post_time = last_reply_post_time,
                                         last_reply_content = last_reply_content)
            } else {
                reply_metadata <- tibble(last_reply_id = NA,
                                         last_reply_uid = NA,
                                         last_reply_post_time = NA,
                                         last_reply_content = NA)
            }
            tb_reply_metadata <- bind_rows(tb_reply_metadata,reply_metadata)
            
        }
        current_page_thread_meta_data <- bind_cols(tb_current_page,tb_reply_metadata)
        #check max page/max tread condition break
        #condition1: last post more than one month
        condition1 <- all((interval(current_page_thread_meta_data[["last_reply_post_time"]],job_time)/months(1)) > 1,na.rm = TRUE)
        #condition2: at max page
        #get max page
        current_max_page <- suppressWarnings((my_session %>% html_node(page_index_css) %>% html_nodes("li") %>% html_text() %>% 
                                                  as.numeric() %>% max(na.rm = TRUE)))
        condition2 <- current_section_page == current_max_page
        if(condition1){
            break() #if lasted reply is more than one month, break
            print("break,condition1:last reply more than 1 month")
        } else if (condition2){
            break()
            print("break,condition2:max page reached")
        }
        thread_meta_data <- bind_rows(thread_meta_data,current_page_thread_meta_data)
        current_section_page <- current_section_page + 1
        cat("Current url:",current_url,"completed\t","Beijing time:",as.character(now()),"\n")
        Sys.sleep(sample(1:4,1))
    }
    Sys.sleep(sample(3:10,1))
    
}


#get sub-section metadata