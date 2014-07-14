#! coding:utf-8
"""utility系
"""
import re
import unicodedata

def clean(s):
    s1=unicodedata.normalize("NFKC", re.sub(r'<br.*?>', '', s)).replace('\n', '').replace('\r', '').replace('&#13;','').replace('&#10;','')
    return re.sub(r" +", " ", s1)

def sub_address(district, str):
    m = re.search(r"(%s.*)$" % district, str)
    if not m:
        return ""
    return m.group()

def address_from_district(str):
    s = sub_address("城南区", str)
    if s:
        return s
    for district in ["東区", "博多区", "中央区", "南区", "西区", "早良区"]:
        s = sub_address(district, str)
        if s:
            return s
    return ""

def parse_price(s):
    s = s.replace("1食", "").replace(",", "").replace("無料", "0").replace("1回","")
    prices = re.findall("\d{2,}", s) 
    return sorted(prices)

def parse_company(com):
    for s in ["株式会社", "合同会社", "社会福祉法人", "医療法人", "特定非営利活動法人", "有限会社", "一般社団法人", "地方公共団体", "生活協同組合", "農協", "NPO", "ＮＰＯ"]:
        if s in com:
            return clean(com).replace("(都道府県)", "").replace("(社協以外)", "")
    return None 
    
def hiragana(s):
    ss = clean(s).replace("\u3094", "#")
    if re.search('^[ぁ-んー#\s]+$', ss):
        return s
    return None

def req(s):
    if not s:
        raise Exception
    return s

def clear_unit(s):
    return re.sub("[件名人％%]", "", s) 
