# Bilibili Web Crawler



## Project Description

Wrote a series of spiders to extract information from bilibili.com

一些列获取bilibili上视频相关信息的爬虫。



## List of Spiders

### 1.search_spider.py
#### How it works?
Given a keyword, the spider will use bilibili's search page to search the keyword and get video information(video likes, views, comments, danmaku, etc.) Results will be saved to `data` folder in `.jl` format.

给定一个关键词后，此爬虫会利用bilibili的搜索界面获取所有和关键词相关的视频信息（视频点赞数，观看数，弹幕，评论等等）。最终结果会以`.jl`格式存到`data`文件夹内。

#### How to use?

In terminal:

`scrapy crawl search_spider.py -a keyword=<YOUR KEY WORD>`

#### 使用

在终端内输入：

`scrapy crawl search_spider.py -a keyword=<关键词>`

#### FYI

1. Currently, bilibili only provides at most 50 pages in search results. So the spider won't crawl all related videos.
2. Bilibili only stores 500 danmaku in it's public API, so the maximum danmaku for each video is 500.
3. This spider only scrape the comments in the first page of video .

#### 须知

1. 现在bilibili的搜索页只提供50页搜索结果，所以这个爬虫也只能爬到这50页的信息

2. bilibili的公开API上只提供500条弹幕，所以即便有的视频有上万条条目，爬虫也只能获取其中的500条

3. 现在这个爬虫只爬每个视频第一页的评论，个人感觉每个视频只有热评比较有用，如果要爬全部评论的话，可能有点得不偿失

## PS:

This project uses Crawlera proxy service. Disable Crawlera settings in settings.py in case of using the spiders without Crawlera.

本项目有用到 Crawlera的代理服务，如果不适用Crawlera的话，请到settings.py里关掉Crawlera的相应设置

