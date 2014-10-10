# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import codecs
import json
from scrapy.contrib.exporter import JsonItemExporter, BaseItemExporter


## Methods overridden to allow writing utf-8 to json files

class JsonWithEncodingPipeline(JsonItemExporter):  
    def __init__(self):
        self.file = codecs.open('scraped_data_utf8.json', 'w', encoding='utf-8')
        self.file.write("[")
        self.first_item = True

    def process_item(self, item, spider):
    	if self.first_item:
            self.first_item = False
        else:
            self.file.write(',\n')

        line = json.dumps(dict(item), ensure_ascii=False) + "\n" 
        self.file.write(line)
        return item 

    def close_spider(self, spider):
    	self.file.write("]")
        self.file.close()
