#navigate from front page to each sub-section
beita_url <- "http://adnmb1.com/Forum"
ss_css <- ".uk-nav-sub a"
#get url of each sub-section
master_page_source <-  read_html(beita_url)
ss_names <- master_page_source %>% 
    html_nodes(ss_css) %>% 
    html_text() %>%
    str_trim() 
ss_href <- master_page_source %>%
    html_nodes(ss_css) %>%
    html_attr("href")
ss_url <- str_c("http://adnmb1.com",ss_href)
#exclude timeline
ss_url_excluded <- ss_url[-str_detect(ss_names,"时间线")]
names(ss_url_excluded) <- ss_names[-str_detect(ss_names,"时间线")]
#get meta data for within 30 days
source("scrape/metatdata_create.R")
#update thread data
source("scrape/get_thread_content.R")
#merge all thread_data into a big table
source("scrape/bind_table.R")
#merge all meta
source("scrape/bind_meta.R")
