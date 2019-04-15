library(rvest)
library(stringr)
library(httr)
library(glue)

get_danmaku <- function(avid){
    myurl <- glue("https://www.bilibili.com/video/av{avid}")
    mysession <- html_session(myurl)
    
    #get danmakuid(cid)
    danmaku_id <- mysession %>%
        html_node("#link2") %>%
        html_attr("value") %>%
        str_extract("(?<=cid=)[0-9]+")
    
    danmaku_server_url <- "http://comment.bilibili.com"
    danmaku_request_url <- glue("{danmaku_server_url}/{danmaku_id}.xml")
    
    # get danmaku
    page_danmaku <- html_session(danmaku_request_url) 
    
    #parse danmaku as text
    raw_text <- content(page_danmaku$response,as="parsed",encoding = "utf-8") %>%
        html_nodes("d") %>%
        html_text()
    
    return(raw_text)
}