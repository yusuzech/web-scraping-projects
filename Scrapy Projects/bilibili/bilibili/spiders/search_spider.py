# -*- coding: utf-8 -*-
import scrapy
import re
from scrapy.http import Request
from bilibili.items import AcvItem
import json
from bilibili.items import VideoItem
from bilibili.items import DanmakuItem
from bilibili.items import CommentItem


class SearchSpiderSpider(scrapy.Spider):
    name = 'search_spider'
    allowed_domains = ['search.bilibili.com',"bilibili.com"]

    def __init__(self,keyword=""):
        self.keyword = keyword

    def start_requests(self):
        self.start_urls = ['http://search.bilibili.com/all?keyword='+self.keyword]
        for url in self.start_urls:
            yield Request(url,callback=self.parse)

    def parse(self, response):
        nodes = response.xpath('//li[contains(@class,"matrix")]')
        for node in nodes:
            url = "https:" + node.xpath('.//a[@title]/@href').extract_first()
            yield Request(url,callback=self.parse_video_detail)
        # get result from top 50 pages
        for i in list(range(2,51)):
            url = response.urljoin("all?keyword="+self.keyword+"&page="+str(i))
            yield Request(url,callback=self.parse)
        
    

    def parse_video_detail(self,response):
        item = AcvItem()
        item["title"] = response.xpath('//h1[@class="video-title"]/@title').extract_first()
        ids_string = re.findall('cid=[0-9]+&aid=[0-9]+',response.text)[0]
        cid,aid = re.findall("[0-9]+",ids_string)
        item["cid"],item["aid"] = cid,aid
        item["upload_time"] = response.xpath('//div[@class="video-data"][1]/span[2]/text()').extract_first()
        yield item

        #get video detail in api
        video_api_base = "http://api.bilibili.com/archive_stat/stat?aid="
        yield Request(video_api_base + aid,callback=self.parse_video_api)

        #get danmaku in api
        danmaku_api_base = "http://comment.bilibili.com/"
        yield Request(danmaku_api_base + cid +".xml",callback=self.parse_danmaku_api)

        #get comment in api
        #let's only get the hottest comments, so we only get the first page
        #pn is for turning pages
        comment_api_base = "https://api.bilibili.com/x/v2/reply?jsonp=jsonp&pn=1&type=1&oid="
        yield Request(comment_api_base + aid,callback=self.parse_comment_api)

    def parse_video_api(self,response):
        item = VideoItem()
        api_data = json.loads(response.text)
        data = api_data["data"]

        item["aid"] = data["aid"]
        item["coin"] = data["coin"]
        item["video_copyright"] = data["copyright"]
        item["danmaku"] = data["danmaku"]
        item["dislike"] = data["dislike"]
        item["favorite"] = data["favorite"]
        item["his_rank"] = data["his_rank"]
        item["like"] = data["like"]
        item["no_reprint"] = data["no_reprint"]
        item["now_rank"] = data["now_rank"]
        item["reply"] = data["reply"]
        item["share"] = data["share"]
        item["view"] = data["view"]
        yield item
        
    def parse_danmaku_api(self,response):
        item = DanmakuItem()
        item["cid"] = re.findall("[0-9]+",response.url)[0]
        item["danmaku"] = response.xpath("//d/text()").extract()
        yield item
        
    def parse_comment_api(self,response):
        item = CommentItem()
        item["aid"] = re.findall("[0-9]+$",response.url)[0]

        data = json.loads(response.text)
        #parsing data in nested structure        
        hot_comment_nodes = data["data"]["hots"]
        hot_comment = [x["content"]["message"] for x in hot_comment_nodes]
        hot_reply = []
        for x in hot_comment_nodes:
            replies = x["replies"]
            if isinstance(replies,list):
                this_reply = [y["content"]["message"] for y in replies]
            else:
                this_reply = [""]
            hot_reply.append(this_reply)
        output = []
        for i in range(len(hot_comment)):
            output.append({"hot_comment":hot_comment[i],
                "hot_reply":hot_reply[i]})
        item["hot_comment"] = output
        yield item
