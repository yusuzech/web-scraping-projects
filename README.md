# List of web-scraping projects

For details of each project, please see them in the folder under this repository. Contact me with my email listed on github if you have any issues.

## [niconico.jp](http://www.nicovideo.jp/)

Niconico(ニコニコ) is one of the most popular Japanese video sharing service on the web with live commenting(danmaku) feature.

**Project Description:**  
This projuct build a script to automatically collect corresponding danmaku given a video id.

## [bilibili.com](https://www.bilibili.com/)

Bilibili is the biggest video sharing website themed around animation, comic, and game (ACG) in China with more than 80 million registered users.

**Project Description**:    
This project build a script which can scrape the danmaku(also known as bullet comments or live comments) given a video id(aid/av_number) in Bilibili.

在本项目中，本人制作了一个脚本，当给定bilibili视频的av号后，脚本将返回对应视频的所有弹幕，详情请见文件夹。

## [zhihu.com](https://www.zhihu.com)

Zhihu(知乎) is a Chinese question-and-answer website where questions are created, answered, edited and organized by the community of its users. 

**Project Description**:  
This project scrapes zhihu's user data and following-follower data. The workflow is to give a topic to start with. It will first get top n related answers or questions and get all these users' information. After that, it can scrape for more following/follower's information recursively.


## [adnmb.com](http://adnmb.com)

adnmb(A岛) is a 4-chan/2ch-like anonymous forum(anonymous to other users, require registration to post) with heathlier content. Though it's small forum, it actually leads in creating new content for Chinese websites. Many memes created in adnmb are used months or years later by the general public in China.

**Project Description**:   
The projects scrape adnmb's all thread content in most recent month. It also generates report automatically. The forum manager is aware of web crawlers.So without registration(with phone number), anonymous users are only allows access to at most 100 page in each thread and each section.


## function

General helpful functions that facilitate web-scraping process. Those functions are imported from [this repo](https://github.com/yusuzech/r-web-scraping-template).  
Those functions help in :    
* use random user agent
* rotate proxy/ip
* auto-retry failed requests
* store all failed requests and retry them after all other tasks are completed

## Utility

Utility functions/scripts such as:  

* Send gmail for: periodic reports, errors and failures etc.

