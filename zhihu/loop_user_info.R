loop_user_info <- function(user_list,my_proxy=NULL){
    #initialize
    user_info_all <- tibble()
    uncomplete_user_info <- c()
    #get user info --------
    for(user in user_list){
        #scrape user -------
        user_info <- get_user_info_json(user,my_proxy = my_proxy)
        
        if(is.null(user_info)){
            print("NULL returned")
            uncomplete_user_info <- c(uncomplete_user_info,user)
            next()
        }
        
        user_info <- user_info %>% 
            mutate(record_date = as.character(Sys.Date()))
        user_info_all <- bind_rows(user_info_all,user_info)
        #print ---------
        cat(match(user,user_list)," in ", length(user_list),"completed. ---",Sys.time(),"\n")
    }
    return(list(complete=user_info_all,
           uncomplete=uncomplete_user_info))
    
}
