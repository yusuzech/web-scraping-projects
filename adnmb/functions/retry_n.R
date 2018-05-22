retry_n <- function(expr,max_try=3,syssleep=0,failing_text = "All tries failed",failing_return = NULL){
    attempt <- 0
    result <- NULL
    while(is.null(result) & attempt < max_try ) {
        attempt <- attempt + 1
        result <- tryCatch(
            eval(expr),
            error = function(e){
                message("Try ",attempt," of ",max_try,"\n")
                message(e$message)
                Sys.sleep(syssleep)
                return(NULL)
            }
        )
    } 
    if(is.null(result)){
        message(failing_text)
        return(failing_return)
    } else {
        return(result)
    }
}