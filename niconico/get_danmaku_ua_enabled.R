library(rvest)
library(httr)
library(stringr)
library(jsonlite)
source("function/random_agent.R")  

get_danmaku <- function(video_id,only_danmaku_text = T){
    video_link <- str_c("http://www.nicovideo.jp/watch/sm",video_id)
    current_agent <- random_agent()
    response_video <- GET(video_link,current_agent)
    api_json <- content(response_video) %>%
        html_node("#js-initial-watch-data") %>%
        html_attr("data-api-data") %>%
        fromJSON()
    
    #get thread id from video id
    thread_id <- api_json$thread$ids$default
    danmaku_api_url <- "http://nmsg.nicovideo.jp/api.json/"
    
    #make request to danmaku server
    request_body_unfilled <- '[{"ping":{"content":"rs:0"}},{"ping":{"content":"ps:0"}},{"thread":{"thread":"my_thread_id","version":"20090904","fork":0,"language":0,"user_id":"","with_global":1,"scores":1,"nicoru":0}},{"ping":{"content":"pf:0"}},{"ping":{"content":"ps:1"}},{"thread_leaves":{"thread":"my_thread_id","language":0,"user_id":"","content":"0-3:100,250","scores":1,"nicoru":0}},{"ping":{"content":"pf:1"}},{"ping":{"content":"rf:0"}}]'
    request_body <- str_replace_all(request_body_unfilled,pattern = fixed("my_thread_id"),replacement = thread_id)
    response <- POST(danmaku_api_url,
                     add_headers(Referer=video_link),
                     current_agent,
                     body = request_body,
                     encode = "raw")
    
    #get danmaku table
    danmaku_table <- content(response,type = "text") %>%
        fromJSON()
    
    #get danmaku text
    danmaku_text <- danmaku_table$chat$content
    
    if(only_danmaku_text == T){
        return(danmaku_text) # only return danmaku text
    } else {
        return(danmaku_table) # return danmaku table as returned in api
    }
}
