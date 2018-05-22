get_topic <- function(topic_id,scroll_down_time=10){
    library(RSelenium)
    library(rvest)
    library(stringr)
    library(lubridate)
    
    
    rmDr <- rsDriver(browser = "chrome")
    myclient <- rmDr$client
    
    #bitcoin topic
    my_url <- glue::glue("https://www.zhihu.com/topic/{topic_id}/hot")
    myclient$navigate(my_url)
    Sys.sleep(2)
    webEle <- myclient$findElements(using = "css",value = "[data-za-detail-view-name]")
    webEle[[2]]$clickElement()
    #wait for pages to load
    Sys.sleep(2)
    replicate(scroll_down_time,{
        myclient$sendKeysToActiveElement(sendKeys = list(key = "end"))
        Sys.sleep(2)
    })
    #get page source
    my_pagesource <- myclient$getPageSource()
    
    
    page_html <- read_html(my_pagesource[[1]])
    answer_nodes <- page_html %>% html_nodes(".List-item")
    answer_table <- tibble()
    for(node in answer_nodes){
        title <- node %>% html_node(".ContentItem-title") %>% html_text()
        content_type <- node %>% html_node("div") %>% html_attr("itemprop")
        content_href <-  node %>% html_node(".ContentItem-title") %>% html_node('[target="_blank"]') %>% html_attr("href")
        user_name <- node %>% html_node(".AuthorInfo-head") %>% html_text()
        user_link <- node %>% html_node(".AuthorInfo-head [href]") %>%  html_attr("href")
        user_id <- str_extract(user_link,"[^\\/]+$")
        upvote <- node %>% html_node(".VoteButton--up") %>% html_text()
        current_row <- tibble(title=title,
                              content_type=content_type,
                              content_href=content_href,
                              user_id=user_id,
                              user_name=user_name,
                              user_link=user_link,
                              upvote=upvote)
        answer_table <- bind_rows(answer_table,current_row)
    }
    
    #fill type of question
    
    meta_table <- answer_table %>%
        mutate(content_type = ifelse(is.na(content_type) & !str_detect(content_href,"answer"),"question",content_type),
               content_type = ifelse(is.na(content_type) & str_detect(content_href,"answer"),"answer",content_type)) %>%
        mutate(question_id = str_extract(content_href,pattern = "(?<=question/)[0-9]+"),
               answer_id = str_extract(content_href,pattern = "(?<=answer/)[0-9]+")) %>%
        select(question_id,answer_id,content_type,everything()) %>%
        mutate(record_date = Sys.Date()) %>% #add datetime
        mutate(thread_id = str_c(question_id,str_replace_na(answer_id,""),sep = "_")) %>%
        select(thread_id,everything()) %>%
        mutate(upvote = as.integer(upvote))
    return(meta_table)
}