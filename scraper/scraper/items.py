# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class ClassItem(scrapy.Item):
	fields = scrapy.Field()
	pass

class GenericItem(scrapy.Item):
	fields = scrapy.Field()

	def __setitem__(self,key,value): # override to allow abitrary fieldnames
		if key not in self.fields:
			self.fields[key] = scrapy.Field()
		self._values[key] = value



	#name = scrapy.Field()
	#company_type = scrapy.Field()
	#company = scrapy.Field()
	#postcode = scrapy.Field()
	#municipality = scrapy.Field()
	#address = scrapy.Field()
	#tel = scrapy.Field()
	#fax = scrapy.Field()
	#hp_address = scrapy.Field()
	#office_no = scrapy.Field()
	#manager_name = scrapy.Field()
	#founding_day = scrapy.Field()
	#traffic = scrapy.Field()
	#home_helper_000 = scrapy.Field()
	#home_helper_001 = scrapy.Field()
	#home_helper_010 = scrapy.Field()
	#home_helper_011 = scrapy.Field()
	#clerk_000 = scrapy.Field()
	#clerk_001 = scrapy.Field()
	#clerk_010 = scrapy.Field()
	#clerk_011 = scrapy.Field()
	#other_000 = scrapy.Field()
	#other_001 = scrapy.Field()
	#other_010 = scrapy.Field()
	#other_011 = scrapy.Field()
	#l_care_worker_100 = scrapy.Field()
	#l_care_worker_101 = scrapy.Field()
	#l_care_worker_110 = scrapy.Field()
	#l_care_worker_111 = scrapy.Field()
	#l_practical_training_100 = scrapy.Field()
	#l_practical_training_101 = scrapy.Field()
	#l_practical_training_110 = scrapy.Field()
	#l_practical_training_111 = scrapy.Field()
	#l_nursing_care_staff_basis_100 = scrapy.Field()
	#l_nursing_care_staff_basis_101 = scrapy.Field()
	#l_nursing_care_staff_basis_110 = scrapy.Field()
	#l_nursing_care_staff_basis_111 = scrapy.Field()
	#l_home_helper1_100 = scrapy.Field()
	#l_home_helper1_101 = scrapy.Field()
	#l_home_helper1_110 = scrapy.Field()
	#l_home_helper1_111 = scrapy.Field()
	#l_home_helper2_100 = scrapy.Field()
	#l_home_helper2_101 = scrapy.Field()
	#l_home_helper2_110 = scrapy.Field()
	#l_home_helper2_111 = scrapy.Field()
	#l_home_helper_traning_100 = scrapy.Field()
	#l_home_helper_traning_101 = scrapy.Field()
	#l_home_helper_traning_110 = scrapy.Field()
	#l_home_helper_traning_111 = scrapy.Field()
	#office_time_week = scrapy.Field()
	#office_time_sat = scrapy.Field()
	#office_time_sun = scrapy.Field()
	#office_time_hol = scrapy.Field()
	#office_time_reghol = scrapy.Field()
	#office_time_memo = scrapy.Field()
	#service_time_week = scrapy.Field()
	#service_time_sat = scrapy.Field()
	#service_time_sun = scrapy.Field()
	#service_time_hol = scrapy.Field()
	#service_time_memo = scrapy.Field()
	#service_area = scrapy.Field()
	#sub_tokuteijigyosyo_1 = scrapy.Field()
	#sub_tokuteijigyosyo_2 = scrapy.Field()
	#sub_tokuteijigyosyo_3 = scrapy.Field()
	#sub_kinnkyujihoumonkaigo = scrapy.Field()
	#seikatsukinoukoujyourenkei = scrapy.Field()
	#kaigosyokuinsyoguu_1 = scrapy.Field()
	#kaigosyokuinsyoguu_2 = scrapy.Field()
	#kaigosyokuinsyoguu_3 = scrapy.Field()
	#jyoukoukaigo = scrapy.Field()
	#area_outside_price = scrapy.Field()
	#cancel_price = scrapy.Field()
	#hutankeigenseido = scrapy.Field()
