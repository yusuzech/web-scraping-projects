#parse all informations into dataframes

parse_address <- function(x){
    label <- x %>%
        html_attr("itemprop")
    content <- x %>%
        html_text()
    output <- content %>%
        setNames(label) %>%
        t() %>%
        as.data.frame()
    return(output)
}

parse_location <- function(x){
    label <- map_chr(x,1)
    content <- map_chr(x,2)
    output <- content %>%
        setNames(label) %>%
        t() %>%
        as.data.frame()
    return(output)
}

parse_status <- function(x){
    output <- x %>%
        setNames("status") %>%
        t() %>%
        as.data.frame()
}

parse_price <- function(x){
    output <- x %>%
        setNames("price") %>%
        t() %>%
        as.data.frame()
}

parse_extra <- function(x){
    output <- x %>%
        setNames("price") %>%
        t() %>%
        as.data.frame()
}