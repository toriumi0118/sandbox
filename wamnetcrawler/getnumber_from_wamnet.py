#! coding: utf-8
"""wamnetからcityCdsに一致するデイまたは居宅の事業所番号を取得してくる
"""

import urllib.parse
import urllib.request
from lxml import etree
from pyquery import PyQuery as pq
import re
import sys
import env

no_re = re.compile(r"JigyosyoCd=(\d+)-00")
total_re = re.compile(r"^(\d+)件$")

cityCds = [401374,401366,401331,401358,401323,401315,401340]

# 粕屋町追加分
# cityCds = [401374,401366,401331,401358,401323,401315,401340,403491]

def main():
    if len(sys.argv) < 2:
        print("事業所番号一覧を保存するファイル名を引数に入力してください")
        exit()
    if len(sys.argv) < 3 or sys.argv[2] not in ["DAY", "KYOTAKU"]:
        print("ターゲットとする事業所区分を入力してください。(DAY, KYOTAKU)")
        exit()

    if sys.argv[2] == "DAY":
        serviceCd = 150
    elif sys.argv[2] == "KYOTAKU":
        serviceCd = 430

    f = open(sys.argv[1], "w")
    start(f, serviceCd)
    f.close()

def start(output, sCd):
    offset = 0
    for cityCd in cityCds:
        while True:
            lu = LoadUrl(offset, cityCd, sCd)
            res = urllib.request.urlopen(urllib.request.Request(lu.url, lu.data()))
            content = res.read().decode("utf-8")

            d = pq(content)
            d("input[value='%s']" % "詳細").each(lambda i,e: write_no(output, e))
            total = total_re.match(d("div.total>div.gaito>span").text()).group(1)
            offset += 5
            if offset > int(total):
               break 
        offset = 0


def write_no(output, inputElement):
    onclick_str = pq(inputElement).attr("onclick") 
    m = no_re.search(onclick_str)
    no = m.group(1)
    print(no)
    output.write(no + "\n")

class LoadUrl:
    url = 'http://www.kaigokensaku.jp/40/index.php?action_kouhyou_pref_search_list_list=true&PrefCd=40'
    
    def __init__(self, offset, cityCd, sCd):
        self.values = {}
        self.values["PrefCd"] = "40"
        self.values["p_offset"] = str(offset)
        self.values["ServiceCd"] = str(sCd)
        self.values["JShikuchosonCd"] = str(cityCd)
        self.values["method"] = "result"
        self.values["action_kouhyou_pref_search_list_list"] = "true"

    def data(self):
        return urllib.parse.urlencode(self.values).encode("utf-8")

if __name__=='__main__':
    main()
