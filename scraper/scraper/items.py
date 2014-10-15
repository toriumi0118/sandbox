# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class GenericItem(scrapy.Item):
	fields = scrapy.Field()

	def __setitem__(self,key,value): # override to allow abitrary fieldnames
		if key not in self.fields:
			self.fields[key] = scrapy.Field()
		self._values[key] = value