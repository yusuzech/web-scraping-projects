# Project Description

Given a video aid/av_number, the script will return all corresponding danmaku in that video.
给定视频av号，脚本将返回对应视频中的所有弹幕。

# How to use

run or source the following [script](https://github.com/yusuzech/web-scraping-projects/blob/master/bilibili/get_danmaku.R)

```r
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
```

Then run the function:

```r
#for example
my_danmaku <- get_danmaku(789232)
```

first ten rows of results:

```
> my_danmaku[1:10]
 [1] "曾經的歌曲如今也100萬歲了"    "是我年齡的數萬倍"             "不知不覺間我也迎來五周歲生日" "你比我自己還要瞭解我呢"       "愛也好戀也罷我也好你也好"    
 [6] "喜歡也好討厭也好它們全部"     "是謊言也好真實也好"           "我都還能唱很多歌哦"           "此刻 一直以來的感謝"          "往後日子里的感謝"  
```
