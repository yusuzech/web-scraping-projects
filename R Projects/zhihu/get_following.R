#get_following
get_following <- function(user_token,try_max = 3,page_try_max =3 ,my_proxy = NULL){
    library(RSQLite)
    library(tidyverse)
    library(jsonlite)
    source("function/html_session_try.R")
    source("function/random_agent.R")
    
    url <- glue::glue("https://www.zhihu.com/people/{user_token}/following")
    
    complete_flag = F
    tried = 1
    while(complete_flag == F & tried <= try_max){
        if(is.null(my_proxy)){
            my_session <- html_session_try(url,do_try = 3,... = c(random_agent()))
        } else {
            source("function/rotate_proxy.R")
            my_session <- html_session_try(url,do_try = 3,... = c(rotate_proxy(proxy_table = my_proxy),random_agent()))
        }
        #fail conditons -----------------
        # request failed
        if(is.atomic(my_session)){
            message("request failed")
            return(NULL)
        }
        #1.login required ----------------
        if(url != my_session$url){
            message("login may be required")
            Sys.sleep(1.1^tried)
            tried <- tried +1
            message("home page load failed")
            ##2.general network failure -----------
        } else if(attributes(my_session)$status_code != 200){
            Sys.sleep(1.1^tried)
            tried <- tried + 1
            message("home page load failed")
        } else {
            complete_flag <- TRUE
        }
    }
    #if request failed -----
    if(complete_flag==F){
        return(NULL)
    }
    
    #check max following page
    following_count <- suppressWarnings((my_session %>% html_nodes(".NumberBoard-itemValue") %>% html_text() %>% parse_number()))
    if(length(following_count) == 0){
        return(NULL)
    } else {
        following_count <- following_count[1]
        if(following_count != 0){
            max_page = ceiling(following_count/20)
        } else {
            message("No following")
            return(NULL)
        }   
    }
    
    cat("user token: ",user_token,"\n","max following page: ",max_page,"\n")
    
    #initialize retry parameters --------------
    all_following_tb <- tibble()
    loop_page <- 1: max_page
    complete_flag <- F
    page_tried <- 1
    loop_later <- c()
    while (complete_flag == F & page_tried <= page_try_max) {
        for(page in loop_page){
            page_url <- glue::glue("https://www.zhihu.com/people/{user_token}/following?page={page}")
            my_session <- html_session_try(url = page_url,do_try = 2,... = c(random_agent(),rotate_proxy(proxy_table = my_proxy)))
            #two situations again -------
            # request failed
            if(is.atomic(my_session)){
                message("request failed")
                return(NULL)
            }
            #1.login required --------
            if(page_url != my_session$url){
                message("login may be required")
                loop_later <- c(loop_later,page)
                next()
            }
            #2.other network issues------------------
            if(attributes(my_session)$status_code != 200){
                message("load page failed")
                loop_later <- c(loop_later,page)
                next()
            }
            
            #get json content----------------
            myjson <- tryCatch(my_session %>% html_node("#data") %>% html_attr("data-state") %>%
                                   fromJSON(),
                               error=function(e){
                                   return(NULL)
                                   message("error in json, reason unknown")
                                   next()
                               })
            #if succeed --------------
            
            user_list <- myjson$entities$users
             attributes_length <- map_dbl(user_list,length)
            # if(!any(attributes_length==18)){
            #     stop("Number of atrributes changed, revision of code is required")
            # }
            following_list <- user_list[attributes_length==18]
            attribute_class <- map_chr(following_list[[1]],class)
            #change list to character
            attribute_class[attribute_class %in% c("list","data.frame")] <- "character"
            #change class to corressponding type
            final_tb <- suppressWarnings(map2_df(data.frame(t(sapply(following_list,c))),attribute_class,~as(.x,.y)))
            
            #bind rows --------
            all_following_tb <- bind_rows(all_following_tb,final_tb)
            cat("page",page," of ", max_page," completed.\t","time:",as.character(Sys.time()),"\n")
        }
        remaing_try_text <- glue::glue("page_tried: {page_tried} ,remainging items: {glue_remaining}. Time: {time_now}",
                                       glue_remaining = str_c(loop_later,collapse = ","),
                                       time_now = as.character(Sys.time()))
        cat(remaing_try_text,"\n")
        Sys.sleep(1.1^page_tried)
        page_tried <- page_tried + 1
        
        if(length(loop_later) == 0){
            complete_flag <-  T
        } else {
            loop_page <- loop_later
            loop_later <- c()
        }
    }

    all_following_tb <- distinct(all_following_tb,urlToken,.keep_all=T)
    all_following_tb <- all_following_tb[,order(colnames(all_following_tb))]
    return(all_following_tb)
}