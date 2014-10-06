# -*- coding: utf-8 -*-
import scrapy
from scraper.util import *
from scraper.items import HoumonItem
from scrapy.contrib.spiders import CrawlSpider, Rule
from bs4 import BeautifulSoup



class BasicSpider(CrawlSpider):

    name = "basicSpider"
    allowed_domains = ["kaigokensaku.jp"]
    start_urls = getStartUrls(110)

    def parse(self, response):
        tree = BeautifulSoup(response.body)
        item = HoumonItem()

        item['name'] = getTextById(tree,175)
        item['company_type'] =getTextById(tree,1)
        item['company'] =getTextById(tree,4)
        item['postcode'] = getTextById(tree,176)
        item['municipality'] = getTextById(tree,177)
        item['address'] = getTextById(tree,178)
        item['tel'] = getTextById(tree,180)
        item['fax'] = getTextById(tree,181)
        item['hp_address'] = getAttributeValueById(tree,183,"href")
        item['office_no'] = getTextById(tree,184)
        item['manager_name'] = getTextById(tree,185)
        item['founding_day'] = getTextById(tree,188)
        item['traffic'] = getTextById(tree,194)
        item['home_helper_000'] = getTextById(tree,195)
        item['home_helper_001'] = getTextById(tree,196)
        item['home_helper_010'] = getTextById(tree,197)
        item['home_helper_011'] = getTextById(tree,198)
        item['clerk_000'] = getTextById(tree,204)
        item['clerk_001'] = getTextById(tree,205)
        item['clerk_010'] = getTextById(tree,206)
        item['clerk_011'] = getTextById(tree,207)
        item['other_000'] = getTextById(tree,209)
        item['other_001'] = getTextById(tree,210)
        item['other_010'] = getTextById(tree,211)
        item['other_011'] = getTextById(tree,212)
        item['l_care_worker_100'] = getTextById(tree,215)
        item['l_care_worker_101'] = getTextById(tree,216)
        item['l_care_worker_110'] = getTextById(tree,217)
        item['l_care_worker_111'] = getTextById(tree,218)
        item['l_practical_training_100'] = getTextById(tree,222)
        item['l_practical_training_101'] = getTextById(tree,223)
        item['l_practical_training_110'] = getTextById(tree,224)
        item['l_practical_training_111'] = getTextById(tree,225)
        item['l_nursing_care_staff_basis_100'] = getTextById(tree,229)
        item['l_nursing_care_staff_basis_101'] = getTextById(tree,230)
        item['l_nursing_care_staff_basis_110'] = getTextById(tree,231)
        item['l_nursing_care_staff_basis_111'] = getTextById(tree,232)
        item['l_home_helper1_100'] = getTextById(tree,236)
        item['l_home_helper1_101'] = getTextById(tree,237)
        item['l_home_helper1_110'] = getTextById(tree,238)
        item['l_home_helper1_111'] = getTextById(tree,239)
        item['l_home_helper2_100'] = getTextById(tree,243)
        item['l_home_helper2_101'] = getTextById(tree,244)
        item['l_home_helper2_110'] = getTextById(tree,245)
        item['l_home_helper2_111'] = getTextById(tree,246)
        item['l_home_helper_traning_100'] = getTextById(tree,250)
        item['l_home_helper_traning_101'] = getTextById(tree,251)
        item['l_home_helper_traning_110'] = getTextById(tree,252)
        item['l_home_helper_traning_111'] = getTextById(tree,253)
        item['office_time_week'] = getTextById(tree,282)
        item['office_time_sat'] = getTextById(tree,283)
        item['office_time_sun'] = getTextById(tree,284)
        item['office_time_hol'] = getTextById(tree,285)
        item['office_time_reghol'] = getTextById(tree,286)
        item['office_time_memo'] = getTextById(tree,287)
        item['service_time_week'] = getTextById(tree,288)
        item['service_time_sat'] = getTextById(tree,289)
        item['service_time_sun'] = getTextById(tree,290)
        item['service_time_hol'] = getTextById(tree,297)
        item['service_time_memo'] = getTextById(tree,292)
        item['service_area'] = getTextById(tree,293)
        item['sub_tokuteijigyosyo_1'] = getAttributeValueById(tree,294,"alt")
        item['sub_tokuteijigyosyo_2'] = getAttributeValueById(tree,294,"alt")
        item['sub_tokuteijigyosyo_3'] = getAttributeValueById(tree,296,"alt")
        item['sub_kinnkyujihoumonkaigo'] = getAttributeValueById(tree,297,"alt")
        item['seikatsukinoukoujyourenkei'] = getAttributeValueById(tree,298,"alt")
        item['kaigosyokuinsyoguu_1'] = getAttributeValueById(tree,299,"alt")
        item['kaigosyokuinsyoguu_2'] = getAttributeValueById(tree,300,"alt")
        item['kaigosyokuinsyoguu_3'] = getAttributeValueById(tree,301,"alt")
        item['jyoukoukaigo'] = getAttributeValueById(tree,302,"alt")
        item['area_outside_price'] = getTextById(tree,340)
        item['cancel_price'] = getTextById(tree,342)
        item['hutankeigenseido'] = getAttributeValueById(tree,343,"alt")

        yield item




