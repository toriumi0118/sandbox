#! coding: utf-8
import csv
import re
import env

class Fukuoka:
    
    def __init__(self):
        self.content = []
        self.srv_fukuoka = []
        self.srv_kasuya = []
        self.srv_other = []
        with open("40FUKUOK.CSV", "r") as f:
            reader = csv.reader(f)
            for row in reader:
                self.content.append(row)
        with open("FUKUOKA_KYOTAKU_SRV.CSV", "r", encoding="utf-8") as f:
            reader = csv.reader(f)
            for row in reader:
                if "福岡市" in row[0]:
                    self.srv_fukuoka.append(row[0])
                elif "糟屋郡" in row[0]:
                    self.srv_kasuya.append(row[0])
                else:
                    self.srv_other.append(row[0])

    def address_of(self, zip_code):
        z = zip_code.replace("〒", "").replace("ー", "").replace("-", "")
        for row in self.content:
           if z != row[2]:
                continue
           s = row[7] + row[8]
           return s.replace("福岡市", "")
    
    def district_of(self, zip_code):
        z = zip_code.replace("〒", "").replace("ー", "").replace("-", "")
        for row in self.content:
           if z != row[2]:
                continue
           s = row[7]
           return s.replace("福岡市", "")
    
    def services(self, data):
        l = []
        has_fukuoka = False
        has_kasuya = False
        for d in data:
            d = d.strip().replace("内", "").replace("全域", "").replace("全般", "").replace("粕屋郡", "糟屋郡").replace("福岡県福岡市", "福岡市")
            if not d:
                continue
            if d in ["福岡市", "粕屋郡", "糟屋郡"]:
                continue
            if len(d) < 2:
                continue
            if not re.search("町|区|市|群", d):
                continue
            for fuku in self.srv_fukuoka:
                if d not in fuku:
                    continue
                if "城南区" in fuku and not d.find("城南区") != -1:
                    continue
                if fuku in l:
                    continue
                l.append(fuku)
                has_fukuoka = True
            for kasuya in self.srv_kasuya:
                if d not in kasuya:
                    continue
                if kasuya in l:
                    continue
                l.append(kasuya)
                has_kasuya = True
            for o in self.srv_other:
                if d not in o:
                    continue
                if o in l:
                    continue
                l.append(o)
        return has_fukuoka, has_kasuya, l 

    def services_in(self, s):
        env.logging.info("サービス提供地域 : " + s)
        ignores = []
        for ig in re.finditer("(\(.+?を除く\))", s, re.MULTILINE):
            igs = re.split('市内|[":：・、,\s　\(\)\*ぁ-ゞ]', ig.group(1))
            ig = self.services(igs)[2]
            ignores = ignores + ig
        for ig in re.finditer("(\（.+?を除く\）)", s, re.MULTILINE):
            igs = re.split('市内|[":：・、,\s　\(\)\*ぁ-ゞ]', ig.group(1))
            ig = self.services(igs)[2]
            ignores = ignores + ig

        s = re.sub("(\(.+?を除く\))", "", s)
        data = re.split('市内|[":：・、,\s　\(\)\*ぁ-ゞ]', s) 
        has_fukuoka, has_kasuya, l = self.services(data)
        for d in data:
            d = d.strip().replace("内", "").replace("全域", "").replace("全般", "").replace("粕屋郡", "糟屋郡").replace("福岡県福岡市", "福岡市")
            if (d == "福岡市" or d == "福岡") and not has_fukuoka:
                l = l + self.srv_fukuoka
                has_fukuoka = True
            if d in ["糟屋郡", "粕屋郡"] and not has_kasuya:
                l = l + self.srv_kasuya
                has_kasuya = True
        if ignores:
            l = list(set(l) - set(ignores))
        env.logging.info("サービス提供地域(解析後) : " + str(l))
        return l
