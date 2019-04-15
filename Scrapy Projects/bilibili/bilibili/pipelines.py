# -*- coding: utf-8 -*-
from bilibili.items import AcvItem
from bilibili.items import VideoItem
from bilibili.items import DanmakuItem
from bilibili.items import CommentItem

from scrapy.exporters import JsonLinesItemExporter
import datetime
import os
# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html


class BilibiliPipeline(object):
    
    # get spider arguments
    @classmethod
    def from_crawler(cls, crawler):
        argvalue = getattr(crawler.spider,"keyword")
        return cls(argvalue)

    def __init__(self,argvalue):
        #create a new folder to store data
        self.job_start_time = str(datetime.datetime.now().strftime('%Y-%m-%d %H-%M-%S'))
        self.datapath = "data/" + self.job_start_time + "-" + argvalue + "/"
        os.mkdir(self.datapath)
        #Acv
        self.acvfile = open(self.datapath + "acv.jl","wb")
        self.acvexporter = JsonLinesItemExporter(self.acvfile,encoding="utf-8")
        #Video
        self.videofile = open(self.datapath + "video.jl","wb")
        self.videoexporter = JsonLinesItemExporter(self.videofile,encoding="utf-8")
        #Danmaku
        self.danmakufile = open(self.datapath + "danmaku.jl","wb")
        self.danmakuexporter = JsonLinesItemExporter(self.danmakufile,encoding="utf-8")
        #Comment
        self.commentfile = open(self.datapath + "comment.jl","wb")
        self.commentexporter = JsonLinesItemExporter(self.commentfile,encoding="utf-8")

    def process_item(self, item, spider):
        if isinstance(item,AcvItem):
            self.acvexporter.export_item(item)
            return item
        if isinstance(item,VideoItem):
            self.videoexporter.export_item(item)
            return item 
        if isinstance(item,DanmakuItem):
            self.danmakuexporter.export_item(item)
            return item
        if isinstance(item,CommentItem):
            self.commentexporter.export_item(item)
            return item
