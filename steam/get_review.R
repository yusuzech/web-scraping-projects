library(rvest)
library(httr)
library(stringr)

#get review from game_id
home_url <- "https://steamcommunity.com/"
game_id <- 675010
review_page <- 3
review_offset <- 10
target_url <- modify_url(home_url,path = str_c("app/",game_id,"/homecontent"),
           query = list(
               userreviewsoffset= review_offset,
               p = review_page,
               workshopitemspage= review_page,
               readytouseitemspage= review_page,
               mtxitemspage= review_page,
               itemspage= review_page,
               screenshotspage= review_page,
               videospage= review_page,
               artpage= review_page,
               allguidepage= review_page,
               webguidepage= review_page,
               integratedguidepage= review_page,
               discussionspage= review_page,
               numperpage= review_offset,
               browsefilter= "mostrecent",
               appid= game_id,
               appHubSubSection= review_offset,
               appHubSubSection= review_offset,
               l= "english",
               filterLanguage= "default",
               searchText="",
               forceanon= 1
           ))
r <- GET(target_url,
         user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36"))

content(r) %>%
    html_nodes(".apphub_CardTextContent") %>%
    html_text() %>%
    str_trim() %>%
    str_extract("([^\\t]*)$")

