#html_session_try adds:
#1.auto retry functionality using exponantial delay(2s,4s,8s,16s etc)
#2.use tryCatch to create robust scraper, any network issues or error will not break the script. It's safe to run it in loops
#3.keep track of unsuccessful request(including both error and warning).Conditions of failed requests are saved as attributes in function output

html_session_try <- function(url,do_try=3,...){
    library(rvest)
    library(httr)
    dots <- c(...)
    #auto retry
    my_session <- NULL
    tried = 0
    while(is.null(my_session) && tried <= do_try) {
        tried <- tried + 1
        tryCatch(
            {
                my_session <- suppressWarnings(html_session(url,dots))
            },
            error=function(cond){
                try_error_message<<-conditionMessage(cond)
                Sys.sleep(2^tried)
            }
        )
    }
    
    #if request failed: error occurs or status_code is not 200, function otput will be NA with attributes:"status_code" and "condition_message"
    if(is.null(my_session)){
        my_session<-structure(NA,
                              status_code=NA,
                              condition_message=try_error_message)
    } else if (status_code(my_session)!=200) {
        my_session<-structure(NA,
                              status_code=status_code(my_session),
                              condition_message=NA)
    } else {
        my_session<-structure(my_session,
                              status_code=status_code(my_session),
                              condition_message=NA)
    }
    
    return(my_session)
}
