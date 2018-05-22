bind_dates_in_list <- function(x){
    date_vector <- integer(0)
    class(date_vector) <- c("POSIXct","POSIXt")
    for (i in 1:length(x)) {
        dates <- x[[i]]
        date_vector <- c(date_vector,dates)
    }
    return(date_vector)
}
