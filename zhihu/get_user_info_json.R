#non orgnization users ----------
get_user_info_json <- function(user_token,my_proxy = NULL){
    library(RSQLite)
    library(tidyverse)
    library(jsonlite)
    source("function/html_session_try.R")
    source("function/random_agent.R")
    
    url <- glue::glue("https://www.zhihu.com/people/{user_token}/activities")
    if(is.null(my_proxy)){
        my_session <- html_session_try(url,do_try = 3,... = c(random_agent()))
    } else {
        source("function/rotate_proxy.R")
        my_session <- html_session_try(url,do_try = 3,... = c(rotate_proxy(proxy_table = my_proxy),random_agent()))
    }
    # request failed
    if(is.atomic(my_session)){
        message("request failed")
        return(NULL)
    }
    #if login required
    if(url != my_session$url){
        message("login required")
        return(NULL)
    }
    
    #check if any error and store error message--------
    if(attributes(my_session)$status_code != 200){
        if(exists("error_table")){
            current_error <<- tibble(url = my_session$url,
                                    status_code = attributes(my_session)$status_code,
                                    condition_message = attributes(my_session)$condition_message)
            error_table <- bind_rows(error_table,current_error)
            message("error occured,condition saved to error_table")
        } else {
            error_table <<- tibble(url = my_session$url,
                                   status_code = attributes(my_session)$status_code,
                                   condition_message = attributes(my_session)$condition_message)
        }
        return(NULL)
    }
    
    #get json content----------------
    myjson <-tryCatch(my_session %>% html_node("#data") %>% html_attr("data-state") %>%
                          fromJSON(),
                      error=function(e){
                          message("error in fromJson, reason unknown")
                          return(NULL)
                      })
    #if doesn't get json ------------------
    if(is.null(myjson)){
        if(exists("error_table")){
            current_error <<- tibble(url = my_session$url,
                                     status_code = NA,
                                     condition_message = "error unknown")
            error_table <- bind_rows(error_table,current_error)
            message("error occured,condition saved to error_table")
        } else {
            error_table <<- tibble(url = my_session$url,
                                   status_code = NA,
                                   condition_message = "error unknown")
        }
        return(NULL)
    }
    
    myjson <- my_session %>% html_node("#data") %>% html_attr("data-state") %>%
        fromJSON()
    personal <- myjson$entities$users[[1]]
    
    #check is orgnization
    if(personal$isOrg){
        message("user is orginization,skip")
        return(NULL)
    }
    index_list <- map_lgl(personal,is.list)
    
    #get non-list columns --------------
    non_list <- personal[!index_list] %>% unlist() %>% t() %>% as.tibble()
    non_list_class <- map(personal[!index_list],class) %>% unlist() 
    non_list_tb <- map2_df(non_list,non_list_class,~as(.x,.y)) %>%
        select(-one_of(c("isFollowed","isFollowing","isPrivacyProtected",
                         "isForceRenamed","isBlocking","isBlocked","allowMessage",
                         "messageThreadToken"))) #drop unnecessary columns
    
    #extract info from lists --------------
    complex_type <- personal[index_list]
    content_nodes <- list(list(name="school",node=complex_type$educations$school$name),
                          list(name="major",node=complex_type$educations$major$name),
                          list(name="job",node=complex_type$employments$job$name),
                          list(name="company",node=complex_type$employments$company$name),
                          list(name="business",node=complex_type$business$name),
                          list(name="location",node=complex_type$locations$name),
                          list(name="badge_topic",node=complex_type$badge$topics),
                          list(name="badge_type",node=complex_type$badge$type))
    output_table <- character(8) %>%
        setNames(c(c("school","major","job","company","business","location","badge_topic","badge_type")))
    
    for(i in 1:length(content_nodes)){
        node_name <- content_nodes[[i]]$name
        content <- content_nodes[[i]]$node
        if(is.null(content)){
            output_table[node_name] <- NA
        } else {
            if(is.list(content)){
                output_table[node_name] <- (complex_type$badge$topics %>% unlist())["name"] %>% str_replace_na("NA") %>% str_c(collapse = ",") 
            } else {
                output_table[node_name] <- content %>% str_replace_na("NA") %>% str_c(collapse = ",")   
            }
        }
    }
    
    
    output_table <- output_table %>% t() %>% as.tibble()
    output_table <- output_table[,order(colnames(output_table))]
    #bind table
    final_output <- bind_cols(non_list_tb,output_table,tibble(record_date = as.character(Sys.Date())))
    return(final_output)
}
