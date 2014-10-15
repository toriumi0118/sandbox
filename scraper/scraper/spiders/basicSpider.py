# -*- coding: utf-8 -*-
import scrapy
from scrapy.item import DictItem, Field
from  scrapy.contrib.loader import ItemLoader
from scraper.util import *
from scrapy.utils.project import get_project_settings
from scraper.items import GenericItem
from scrapy.contrib.spiders import CrawlSpider, Rule
from bs4 import BeautifulSoup



class BasicSpider(CrawlSpider):
    settings = get_project_settings()
    name = "basicSpider"
    allowed_domains = ["kaigokensaku.jp"]
    start_urls = ("""http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_2013_001_kani=true&JigyosyoCd=4071103990-00&PrefCd=40&VersionCd=001""",)    
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
                elif csvArray[9][0:5] == "\".attr":
                    attribute = csvArray[9].split("\"")[4]
                    self.attributeFields.append((csvArray[1],csvArray[8]),attribute) 



    def parse(self, response):                         
        tree = BeautifulSoup(response.body)
        i = GenericItem()


        ## 経度・緯度はjavascriptから
        i["latitude"] = re.search("LatVal\s*\=\s*\'([0-9]+\.[0-9]+)\'",response.body).group(1)
        i["longitude"] = re.search("LonVal\s*\=\s*\'([0-9]+\.[0-9]+)\'",response.body).group(1)

        for field in self.plainFields:
            (columnName,idNumber) = field
            i[columnName] = getTextById(tree,idNumber)

        for field in self.attributeFields:
            (columnName,idNumber,attribute) = field
            i[columnName] = getTextByIdAttribute(tree,idNumber,attribute)

        yield i




