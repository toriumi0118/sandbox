#! coding: utf-8 
"""デイサービスの情報を取得する
"""

import sys
import re
import unicodedata
import env
from lxml import etree
from pygeocoder import Geocoder
from pyquery import PyQuery as pq
from fukuoka import Fukuoka

class Office:
    summary_url = 'http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_%s_%s_kani=true&JigyosyoCd=%s-00&PrefCd=%s&VersionCd=%s'
    feature_url = 'http://www.kaigokensaku.jp/40/index.php?action_kouhyou_pref_detail_feature_index=true&JigyosyoCd=%s-00&PrefCd=%s&YNendo=%s&VersionCd=%s'
    detail_url  = 'http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_%s_%s_kihon=true&JigyosyoCd=%s-00&PrefCd=%s&VersionCd=%s'
    run_url     = 'http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_%s_%s_unei=true&JigyosyoCd=%s-00&PrefCd=%s&VersionCd=%s'
    other_url   = 'http://www.kaigokensaku.jp/40/index.php?action_kouhyou_pref_detail_original_index=true&JigyosyoCd=%s-00&PrefCd=%s&YNendo=%s&VersionCd=%s'

    def __init__(self, nendo, code, no, pref):
        self.header = []
        self.record = []
        self.nendo = nendo
        self.code = code
        self.no = no
        self.pref = pref
        self.ds = pq(url = self.get_summary())
        self.df = pq(url = self.get_feature())
        self.dd = pq(url = self.get_detail())
        self.dr = pq(url = self.get_run())
        self.do = pq(url = self.get_other())
        if pref == '40':
            self.zips = Fukuoka()

    def raw_html(self):
        s = self.ds.html()
        s += self.df.html()
        s += self.dd.html()
        s += self.dr.html()
        s += self.do.html()
#        return s.replace("\xa9", "copy right").replace("\xa0", " ").replace("\u208b", "-").replace("\u2782", "3")
        s = s.replace("/img/ico_hatena.gif", "./img/ico_hatena.gif")
        s = s.replace("/img/pref/ico_jigyosho_ari.gif", "./img/ico_jigyosho_ari.gif")
        s = s.replace("/img/pref/ico_jigyosho_gaitonashi.gif", "./img/ico_jigyosho_gaitonashi.gif")
        s = s.replace("/img/pref/ico_jigyosho_hyphen.gif", "./img/ico_jigyosho_hyphen.gif")
        s = s.replace("/img/pref/ico_jigyosho_maru.gif", "./img/ico_jigyosho_maru.gif")
        s = s.replace("/img/pref/ico_jigyosho_nashi.gif", "./img/ico_jigyosho_nashi.gif")
        s = s.replace("/img/pref/ico_jigyosho_tashounashi.gif", "./img/ico_jigyosho_tashounashi.gif")
        return s

    def get_summary(self):
        return self.summary_url % (self.nendo, self.code, self.no, self.pref, self.code)

    def get_feature(self):
        return self.feature_url % (self.no, self.pref, self.nendo, self.code)

    def get_detail(self):
        return self.detail_url % (self.nendo, self.code, self.no, self.pref, self.code)

    def get_run(self):
        return self.run_url % (self.nendo, self.code, self.no, self.pref, self.code)

    def get_other(self):
        return self.other_url % (self.no, self.pref, self.nendo, self.code)

    """ private method"""
    def _get(self, d, name):
        return d('th[abbr="%s"]' % name).next('td').html()

    def _str_clean(self, str):
        s1 = unicodedata.normalize("NFKC", re.sub(r'<br.*?>', '', str)).replace('\n', '').replace('\r', '').replace('&#13;','').replace('&#10;','')
        return re.sub(r" +", " ", s1)

    def _search_address(self, district, str):
        m = re.search(r"(%s.*)$" % district, str)
        if not m:
            return ""
        return m.group()

    def _replace_address(self, str):
        s = self._search_address("城南区", str)
        if s:
            return s
        for district in ["東区", "博多区", "中央区", "南区", "西区", "早良区"]:
            s = self._search_address(district, str)
            if s:
                return s
        return ""

    def _get_address(self):
        ad = self.get_split(self.ds, "住所", 1).replace("福岡県", "").replace("福岡市","").replace(" ", "")
        ad = re.sub(r'(\d+)ー(\d+)', r'\1-\2', ad)
        ad1 = self._replace_address(ad)
        if not ad1 or ad1 == "":
            if re.match(r"^[\d|-][\d|-]*[\d|-]$", ad):
                ad1 = self.zips.address_of(self.get_split(self.ds, "住所", 0)) + ad
                env.logging.info('%sの住所は番地のみ(%s)で構成されているため郵便番号で解析しました。→%s' % (self.get_name(), ad, ad1))
                print('%sの住所は番地のみ(%s)で構成されているため郵便番号で解析しました。→%s' % (self.get_name(), ad, ad1))
            else:
                ad1 = self.zips.district_of(self.get_split(self.ds, "住所", 0)) + ad
                env.logging.info('%sは地区をもっていないため、郵便番号で補間しました。→%s' % (ad, ad1))
                print('%sは地区をもっていないため、郵便番号で補間しました。→%s' % (ad, ad1))
                

        try:
            ad2 = self.get_split(self.ds, "住所", 2)
        except IndexError:
            return ad1
        try:
            ad3 = self.get_split(self.ds, "住所", 3)
        except IndexError:
            return ad1 + " " + ad2
        return ad1 + " " + ad2 + " " + ad3
    
    def _parse_price(self, s):
        s = s.replace("1食", "").replace(",", "").replace("無料", "0").replace("1回","")
        prices = re.findall("\d+", s) 
        return sorted(prices)

    def _get_company(self, com):
        for s in ["株式会社", "合同会社", "社会福祉法人", "医療法人", "特定非営利活動法人", "有限会社", "一般社団法人", "地方公共団体", "生活協同組合", "農協", "NPO", "ＮＰＯ"]:
            if s in com:
                return self._str_clean(com).replace("(都道府県)", "").replace("(社協以外)", "")
        return None 

    def _hiragana(self, s):
        ss = self._str_clean(s).replace("\u3094", "#")
        if re.search('^[ぁ-んー#\s]+$', ss):
            return ss
        return None

    """ public method"""
    def get_no(self):
        return self.dd('th:contains("事業所番号")').filter(lambda i, this: pq(this).text() == "事業所番号").next("td").text()

    def get_company(self):
        com_name = self.dd('th[abbr="名称"]').parent('tr').next('tr>td').text()
        com = self._get_company(com_name)
        if com:
            return com
        raw_com_name = com_name
        if "かぶしきがいしゃ" in com_name or "かぶしきかいしゃ" in com_name:
            com_name = ""

        com_name = self._str_clean(com_name).replace("(医)", "").replace("(株)", "").replace("(有)", "")
        com = self._get_company(self.dd('th[abbr="法人等の種類"]~td').text())
        com_other = self._get_company(self.dd('th[abbr="（その他の場合、その名称）"]~td').text())

        if com and ("株式会社" in com or "農協" in com):
            return self._str_clean(com + " " + com_name)
        if com_other and "株式会社" in com_other:
            return self._str_clean(com_other + " " + com_name)
        if com:
            return self._str_clean(com + " " + com_name)
        if com_other:
            return self._str_clean(com_other + " " + com_name)
        com_huri = self._get_company(self.dd('th[abbr="（ふりがな）"]~td').text())
        if com_huri:
            return com_huri
        return self._str_clean(raw_com_name)

    def get_name(self):
        name = self.ds('th[abbr="事業所名"]').parent('tr').next('tr>td').text()
        clean_name = self._hiragana(name)
        if clean_name:
            n = self.get(self.dd, "(ふりがな)")
            env.logging.info('%sがひらがなで構成されているため不正です。調整します。→%s' % (clean_name, n))
            print('%sがひらがなで構成されているため不正です。調整します。→%s' % (clean_name, n))
            return n
        return self._str_clean(name).replace("-", "ー").replace("~", "～") 

    def get_address(self):
        return self._get_address().strip()

    def get_parse_meal_price(self, d, name):
        s = self._str_clean(self._get(d, name))
        launch = None
        for price in self._parse_price(s):
            launch = price if len(price) < 4 and (not launch or max(launch, price) == price) else launch 
        snack = None
        for price in self._parse_price(s):
            snack = price if launch and launch != price and len(price) < 4 and int(price) < 300 and (not snack or max(snack, price) == price) else snack 
        return (launch, snack)

    def get_geocode(self):
        ad = self._get_address()
        try:
            return Geocoder.geocode("福岡県" + ad)[0].coordinates
        except:
            rep = re.match(r"((.+-\d+)|(.+\d+号))", ad).group()
            print('%sのgeocodeが見つかりませんでした。調整します。→%s' % (ad, rep))
            return Geocoder.geocode("福岡県" + rep)[0].coordinates

    def get_split(self, d, name, index):
        return self._str_clean(re.split(r'<br.*?>', d('th[abbr="%s"]' % name).next('td').html())[index]) 

    def get(self, d, name):
        return self._str_clean(self._get(d, name)) if self._get(d, name) else ""

    def get_ari(self, d, name):
        return str(1 if re.search(r'ico_jigyosho_ari.gif', self.get(d, name)) else 0)

    def get_business_time(self, d, title, name):
        times = self._str_clean(self._get(d, name)) if self._get(d, name) else ""
        if times == "":
            self.record.append("")
            self.record.append("")
            return
        t = times.replace('時','').replace('分','').replace('~','-').split("-")
        self.record.append("" if t[0] == "0" or t[0] == "00" or t[0] == "000" or t[0] == "0000" else t[0])
        self.record.append("" if t[1] == "0" or t[1] == "00" or t[1] == "000" or t[1] == "0000" else t[1])

    def get_2_column(self, d, name):
        s1 = self._str_clean(d('th[abbr="%s"]' % name).next('td').text())
        s2 = self._str_clean(d('th[abbr="%s"]' % name).next('td').next('td').text())
        return (s1, s2)

    def get_br2rn(self, d, name):
        s = self._get(d, name)
        s = unicodedata.normalize("NFKC", re.sub(r'<br.*?>','\r\n', s.replace('\n', '').replace('\r', '').replace('&#13;','').replace('&#10;','')).replace("　", " "))
        return re.sub(r" +", " ", s)

    def req(self, s):
        if not s:
            raise Exception
        return s

    def setup(self):
        self.header.append("事業所番号")
        self.record.append(self.get_no())
        self.header.append("事業所名")
        self.record.append(self.req(self.get_name()))
        self.header.append("法人名")
        self.record.append(self.req(self.get_company().strip()))
        self.header.append("住所")
        self.record.append(self.req(self.get_address()))
        geo = self.get_geocode()
#        geo = ["",""] 
        self.header.append("緯度")
        self.record.append(str(geo[0]))
        self.header.append("経度")
        self.record.append(str(geo[1]))
        self.header.append("TEL")
        self.record.append(self.req(self.get_split(self.ds, '連絡先', 0).replace('Tel:','').replace('-','').replace('‐', '').replace("(", "").replace(")", "")))
        self.header.append("FAX")
        self.record.append(self.get_split(self.ds, '連絡先', 1).replace('Fax:','').replace('-','').replace('‐', '').replace("(", "").replace(")", ""))

        self.header.append("介護予防サービスの実施")
        self.record.append(self.get_ari(self.ds, '介護予防サービスの実施'))
        # parse intのためにint()を行っている
        self.header.append("定員数")
        self.record.append(str(int(self.get(self.dd, '利用定員').replace("人", "").replace("名", ""))))
        self.header.append("延長サービスの有無")
        self.record.append(self.get_ari(self.ds, '延長サービスの有無'))
        self.header.append("サービス提供体制強化加算(I)")
        self.record.append(self.get_ari(self.ds, 'サービス提供体制強化加算（Ⅰ）'))
        self.header.append("サービス提供体制強化加算(II)")
        self.record.append(self.get_ari(self.ds, 'サービス提供体制強化加算（Ⅱ）'))
        self.header.append("サービス提供体制強化加算(III)")
        self.record.append(self.get_ari(self.ds, 'サービス提供体制強化加算（Ⅲ）（予防を除く）'))
        self.header.append("個別機能訓練加算(I)")
        self.record.append(self.get_ari(self.ds, '個別機能訓練加算(Ⅰ)'))
        self.header.append("個別機能訓練加算(II)")
        self.record.append(self.get_ari(self.ds, '個別機能訓練加算(Ⅱ)'))
        self.header.append("入浴介助")
        self.record.append(self.get_ari(self.ds, '入浴介助の実施'))
        self.header.append("若年性認知症利用者の受入")
        self.record.append(self.get_ari(self.ds, '若年性認知症利用者の受入'))
        self.header.append("栄養改善サービス")
        self.record.append(self.get_ari(self.ds, '栄養改善サービスの実施'))
        self.header.append("口腔機能向上サービス")
        self.record.append(self.get_ari(self.ds, '口腔機能向上サービスの実施'))
        self.header.append("介護職員処遇改善加算(I)")
        self.record.append(self.get_ari(self.ds, '介護職員処遇改善加算（Ⅰ）'))
        self.header.append("介護職員処遇改善加算(II)")
        self.record.append(self.get_ari(self.ds, '介護職員処遇改善加算（Ⅱ）'))
        self.header.append("介護職員処遇改善加算(III)")
        self.record.append(self.get_ari(self.ds, '介護職員処遇改善加算（Ⅲ）'))
        self.header.append("食費")
        self.record.append(self.get_br2rn(self.ds, '食費とその算定方法').replace("~", "～"))
        prices = self.get_parse_meal_price(self.ds, '食費とその算定方法')
        self.header.append("朝食")
        self.record.append("")
        self.header.append("昼食")
        self.record.append(prices[0])
        self.header.append("夕食")
        self.record.append("")
        self.header.append("おやつ")
        self.record.append(prices[1])
        staffs = self.get_2_column(self.ds, "看護職員")
        self.header.append("常勤看護職員数")
        self.record.append(staffs[0].replace("人", ""))
        self.header.append("非常勤看護職員数")
        self.record.append(staffs[1].replace("人", ""))
        staffs = self.get_2_column(self.ds, "介護職員")
        self.header.append("常勤介護職員数")
        self.record.append(staffs[0].replace("人", ""))
        self.header.append("併設施設種別")
        self.record.append(self.get_br2rn(self.ds, '法人等が実施するサービス<br />（または、同一敷地で実施するサービスを掲載）').strip("\r\n"))
        self.header.append("営業時間　平日 from")
        self.header.append("営業時間　平日 to")
        self.get_business_time(self.ds, '営業時間', '平日')
        self.header.append("営業時間　土曜 from")
        self.header.append("営業時間　土曜 to")
        self.get_business_time(self.ds, '営業時間', '土曜')
        self.header.append("営業時間　日曜 from")
        self.header.append("営業時間　日曜 to")
        self.get_business_time(self.ds, '営業時間', '日曜')
        self.header.append("営業時間　祝日 from")
        self.header.append("営業時間　祝日 to")
        self.get_business_time(self.ds, '営業時間', '祝日')
        self.header.append("送迎サービス範囲備考")
        self.record.append(self.get(self.ds, 'サービス提供地域'))
        self.header.append("設立年月日")
        self.record.append(self.req(pq(self.get(self.dd, "事業の開始（予定）年月日")).remove("div").text().replace("/", "").strip()))

