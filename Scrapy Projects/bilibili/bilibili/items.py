# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class AcvItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    title =scrapy.Field()
    aid =scrapy.Field()
    cid =scrapy.Field()
    upload_time = scrapy.Field()

class VideoItem(scrapy.Item):
    aid   = scrapy.Field()
    coin = scrapy.Field()
    video_copyright = scrapy.Field()
    total_danmaku = scrapy.Field()
    dislike = scrapy.Field()
    favorite = scrapy.Field()
    his_rank = scrapy.Field()
    like = scrapy.Field()
    no_reprint = scrapy.Field()
    now_rank = scrapy.Field()
    reply = scrapy.Field()
    share = scrapy.Field()
    view = scrapy.Field()
class DanmakuItem(scrapy.Item):
    cid = scrapy.Field()
    danmaku = scrapy.Field()
class CommentItem(scrapy.Item):
    aid = scrapy.Field()
    hot_comment = scrapy.Field()
    replies = scrapy.Field()