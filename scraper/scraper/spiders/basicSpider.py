# -*- coding: utf-8 -*-
import scrapy
from scrapy.http import Request
from scrapy.item import DictItem, Field
from scrapy.utils.project import get_project_settings
from  scrapy.contrib.loader import ItemLoader
from scraper.util import *
from scraper.items import GenericItem
from scrapy.contrib.spiders import CrawlSpider
from bs4 import BeautifulSoup
import re



class BasicSpider(CrawlSpider):
    settings = get_project_settings()
    name = "basicSpider"
    start_urls = ("""http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_2013_001_kani=true&JigyosyoCd=4071103990-00&PrefCd=40&VersionCd=001""",)    
    allowed_domains = ["kaigokensaku.jp"]
    def __init__(self,serviceType=None):
        #self.start_urls = getStartUrls(int(serviceType))
        self.path = ".\\scraper\\tableDefinitions\\"+serviceType+".csv"    
        self.tableDefinitions = file(self.path)
        self.plainFields =[]
        self.attributeFields = []
        self.allFields = []
        ## CSV DEFINITION
        ## No,項目名,型,長さ,少数,必須,PK,備考,diffid,
        ## 2,id,TEXT,,,,,事業所名称,175,.innerHTML
        ## 0 1   2                 8      9
        ##########################################
        for line in self.tableDefinitions:
            csvArray = line.split(",")
            if(csvArray[0].isdigit()):
                self.allFields.append(csvArray[1])
                if csvArray[9][0:10] == ".innerHTML":
                    self.plainFields.append((csvArray[1],csvArray[8]))
                elif csvArray[9][0:6] == "\".attr":
                    attribute = csvArray[9].split("\"")[3]
                    self.attributeFields.append((csvArray[1],csvArray[8],attribute)) 


    def saveFieldsToItem(self,tree,i):
        for field in self.plainFields:
            (columnName,idNumber) = field
            valueFromPage = getTextById(tree,idNumber)
            if valueFromPage:
                i[columnName] = valueFromPage

        for field in self.attributeFields:
            (columnName,idNumber,attribute) = field
            valueFromPage = getAttributeValueById(tree,idNumber,attribute)
            if valueFromPage:
                i[columnName] = valueFromPage

    def parse(self, response):                         
        tree = BeautifulSoup(response.body)
        i = GenericItem()


        ## 経度・緯度はjavascriptから
        i["latitude"] = re.search("LatVal\s*\=\s*\'([0-9]+\.[0-9]+)\'",response.body).group(1)
        i["longitude"] = re.search("LonVal\s*\=\s*\'([0-9]+\.[0-9]+)\'",response.body).group(1)

        self.saveFieldsToItem(tree,i)
       

        regex = re.compile(r"""action_kouhyou_detail_([0-9]+)_([0-9]+)_kani=true\&JigyosyoCd=([0-9\-]+)\&PrefCd=([0-9]+)\&VersionCd=([0-9]+)""")
        [details] = regex.findall(response.url)
        (year,versionCd1,jigyosyoCd,pref,versionCd2) = details
        url = "http://www.kaigokensaku.jp/40/index.php?action_kouhyou_pref_detail_feature_index=true&JigyosyoCd="+jigyosyoCd+"&PrefCd="+pref+"&YNendo="+year+"&VersionCd="+versionCd1
        request = Request(url, callback=self.parseTokushoku)
        request.meta['details']=details
        request.meta['item'] = i
        yield request


    def parseTokushoku(self,response):
        i = response.meta['item']
        (year,versionCd1,jigyosyoCd,pref,versionCd2) = response.meta['details']
        tree = BeautifulSoup(response.body)
        self.saveFieldsToItem(tree,i)
        url = "http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_"+year+"_"+versionCd1+"_kihon=true&JigyosyoCd="+jigyosyoCd+"&PrefCd="+pref+"&YNendo="+year+"&VersionCd="+versionCd2
        request = Request(url, callback=self.parseShousai)
        request.meta['item'] = i
        request.meta['details'] = response.meta['details']
        yield request

        
    def parseShousai(self,response):
        i = response.meta['item']
        (year,versionCd1,jigyosyoCd,pref,versionCd2) = response.meta['details']
        tree = BeautifulSoup(response.body)
        self.saveFieldsToItem(tree,i)
        url = "http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_"+year+"_"+versionCd1+"_unei=true&JigyosyoCd="+jigyosyoCd+"&PrefCd="+pref+"&YNendo="+year+"&VersionCd="+versionCd2
        request = Request(url, callback=self.parseJoutai)
        request.meta['item'] = i
        request.meta['details'] = response.meta['details']
        yield request

    def parseJoutai(self,response):
        i = response.meta['item']
        (year,versionCd1,jigyosyoCd,pref,versionCd2) = response.meta['details']
        tree = BeautifulSoup(response.body)
        self.saveFieldsToItem(tree,i)
        url = "http://www.kaigokensaku.jp/40/index.php?action_kouhyou_pref_detail_original_index=true&JigyosyoCd="+jigyosyoCd+"&PrefCd="+pref+"&YNendo="+year+"&VersionCd="+versionCd2
        request = Request(url, callback=self.parseHoka)
        request.meta['item'] = i
        request.meta['details'] = response.meta['details']
        yield request

    def parseHoka(self,response):
        i = response.meta['item']
        tree = BeautifulSoup(response.body)
        self.saveFieldsToItem(tree,i)
        yield i

