# List of web-scraping projects

For details of each project, please see them in the folder under this repository. Contact me with my email listed on github if you have any issues.

## Scrapy Projects
### [bilibili.com Video Information Crawler](https://github.com/yusuzech/web-scraping-projects/tree/master/Scrapy%20Projects/bilibili)
Project Description:
Given a key word, get all relevant information(video, danmaku and comments) using [search.bilibili.com](https://search.bilibili.com/).

提供关键词后，提取B站上所有相关视频，弹幕及评论信息。

## R Projects

### [niconico.jp danmaku auto collection]((https://github.com/yusuzech/web-scraping-projects/tree/master/R%20Projects/niconico/README.md)

Niconico(ニコニコ) is one of the most popular Japanese video sharing service on the web with live commenting(danmaku) feature.

**Project Description:**  
In this project, I build a script to automatically collect corresponding danmaku given a video id.

ニコニコ弾幕Webスクレイピング.

### [bilibili.com danmaku auto collection]((https://github.com/yusuzech/web-scraping-projects/tree/master/R%20Projects/bilibili/README.md)

Bilibili is the biggest video sharing website themed around animation, comic, and game (ACG) in China with more than 80 million registered users.

**Project Description**:    
In this project, I build a script which can scrape the danmaku(also known as bullet comments or live comments) given a video id(aid/av_number).

bilili弹幕数据获取脚本/爬虫：给定bilibili视频的av号，脚本将返回对应视频的所有弹幕，详情请见文件夹。

### [zhihu.com follower/followee data scraping]((https://github.com/yusuzech/web-scraping-projects/tree/master/R%20Projects/douyu/README.md)

Zhihu(知乎) is a Chinese question-and-answer website where questions are created, answered, edited and organized by the community of its users. 

**Project Description**:  
This project scrapes zhihu's user data and following-follower data. The workflow is to give a topic to start with. It will first get top n related answers or questions and get all these users' information. After that, it can scrape for more following/follower's information recursively.

知乎爬虫/数据获取脚本，给定一个知乎话题，自动获取话题下相关问题，回答和用户信息，以此获取对应用户的关注者与被关注者信息。

### [adnmb.com thread data collection]((https://github.com/yusuzech/web-scraping-projects/tree/master/R%20Projects/adnmb/README.md)

adnmb(A岛) is a 4-chan/2ch-like anonymous forum(anonymous to other users, require registration to post) with heathlier content. Though it's small forum, it actually leads in creating new content for Chinese websites. Many memes created in adnmb are used months or years later by the general public in China.

**Project Description**:   
The projects scrape adnmb's all thread content in most recent month. It also generates report automatically. The forum manager is aware of web crawlers.So without registration(with phone number), anonymous users are only allows access to at most 100 page in each thread and each section.

A岛爬虫/串内信息获取， 运行后将自动获取近一个月内所有串内的信息。

### function

General helpful functions that facilitate web-scraping process. Those functions are imported from [this repo](https://github.com/yusuzech/r-web-scraping-template).  
Those functions help in :    
* use random user agent
* rotate proxy/ip
* auto-retry failed requests
* store all failed requests and retry them after all other tasks are completed

### Utility

Utility functions/scripts such as:  

* Send gmail for: periodic reports, errors and failures etc.

