#! coding: utf-8 
import sys
import re
import unicodedata
import env
from lxml import etree
from pygeocoder import Geocoder
from pyquery import PyQuery as pq
from fukuoka import Fukuoka
import ut

class Kyotaku:
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
            self.fukuoka = Fukuoka()

    def url(self):
        return self.get_no() + "," + self.get_name() + "," + self.get_summary()

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

    def _get_address(self):
        ad = self.get_split(self.ds, "住所", 1).replace("福岡県", "").replace("福岡市","").replace(" ", "")
        ad = re.sub(r'(\d+)ー(\d+)', r'\1-\2', ad)
        ad1 = ut.address_from_district(ad)
        if not ad1 or ad1 == "":
            if re.match(r"^[\d|-][\d|-]*[\d|-]$", ad):
                ad1 = self.fukuoka.address_of(self.get_split(self.ds, "住所", 0)) + ad
                env.logging.info('%sの住所は番地のみ(%s)で構成されているため郵便番号で解析しました。→%s' % (self.get_name(), ad, ad1))
                print('%sの住所は番地のみ(%s)で構成されているため郵便番号で解析しました。→%s' % (self.get_name(), ad, ad1))
            else:
                ad1 = self.fukuoka.district_of(self.get_split(self.ds, "住所", 0)) + ad
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

    """ public method"""
    def get_no(self):
        return self.dd('th:contains("事業所番号")').filter(lambda i, this: pq(this).text() == "事業所番号").next("td").text()

    def get_company(self):
        com_name = self.dd('th[abbr="名称"]').parent('tr').next('tr>td').text()
        com = ut.parse_company(com_name)
        if com:
            return com
        raw_com_name = com_name
        if "かぶしきがいしゃ" in com_name or "かぶしきかいしゃ" in com_name:
            com_name = ""

        com_name = ut.clean(com_name).replace("(医)", "").replace("(株)", "").replace("(有)", "")
        com = ut.parse_company(self.dd('th[abbr="法人等の種類"]~td').text())
        com_other = ut.parse_company(self.dd('th[abbr="（その他の場合、その名称）"]~td').text())

        if com and ("株式会社" in com or "農協" in com):
            return ut.clean(com + " " + com_name)
        if com_other and "株式会社" in com_other:
            return ut.clean(com_other + " " + com_name)
        if com:
            return ut.clean(com + " " + com_name)
        if com_other:
            return ut.clean(com_other + " " + com_name)
        com_huri = ut.parse_company(self.dd('th[abbr="（ふりがな）"]~td').text())
        if com_huri:
            return com_huri
        return ut.clean(raw_com_name)

    def get_name(self):
        name = self.ds('th[abbr="事業所名"]').parent('tr').next('tr>td').text()
        clean_name = ut.hiragana(name)
        if clean_name:
            n = self.get(self.dd, "(ふりがな)")
            env.logging.info('%sがひらがなで構成されているため不正です。調整します。→%s' % (clean_name, n))
            print('%sがひらがなで構成されているため不正です。調整します。→%s' % (clean_name, n))
            return n
        return ut.clean(name).replace("-", "ー").replace("~", "～") 

    def get_address(self):
        return self._get_address().strip()

    def get_parse_meal_price(self, d, name):
        s = ut.clean(self._get(d, name))
        launch = None
        for price in ut.parse_price(s):
            launch = price if len(price) < 4 and (not launch or max(launch, price) == price) else launch 
        snack = None
        for price in ut.parse_price(s):
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

    def get_hp(self):
        hp = self.get_split(self.ds, '連絡先', 2).strip()
        if not hp:
            return None
        hpd = pq(hp)
        return hpd.attr("href")
        

    def get_split(self, d, name, index):
        return ut.clean(re.split(r'<br.*?>', d('th[abbr="%s"]' % name).next('td').html())[index]) 

    def get(self, d, name):
        return ut.clean(self._get(d, name)) if self._get(d, name) else ""

    def get_ari(self, d, name):
        return str(1 if re.search(r'ico_jigyosho_ari.gif', self.get(d, name)) else 0)

    def get_business_time(self, d, title, name):
        times = ut.clean(self._get(d, name)) if self._get(d, name) else ""
        if times == "":
            self.record.append("")
            self.record.append("")
            return
        t = times.replace('時','').replace('分','').replace('~','-').split("-")
        self.record.append("" if t[0] == "0" or t[0] == "00" or t[0] == "000" or t[0] == "0000" else t[0])
        self.record.append("" if t[1] == "0" or t[1] == "00" or t[1] == "000" or t[1] == "0000" else t[1])

    def get_2_column(self, d, name):
        s1 = ut.clean(d('th[abbr="%s"]' % name).next('td').text())
        s2 = ut.clean(d('th[abbr="%s"]' % name).next('td').next('td').text())
        return (s1, s2)

    def get_br2rn(self, d, name):
        s = self._get(d, name)
        s = unicodedata.normalize("NFKC", re.sub(r'<br.*?>','\r\n', s.replace('\n', '').replace('\r', '').replace('&#13;','').replace('&#10;','')).replace("　", " "))
        return re.sub(r" +", " ", s)

    def get_2_th(self, d, n1, n2):
        return ut.clean(d("th[abbr='%s']" % n1).parents("tr").find("th[abbr='%s']" % n2).next("td").text())

    def get_clear_unit(self, d, name):
        s = self.get(d, name)
        return ut.clear_unit(s)
    
    def get_pt_value(self, d, name):
        s = ut.clean(d("th[abbr='%s']" % name).next("td").next("td").text())
        return ut.clear_unit(s)

    def get_join_values(self, d, name):
        s1 = ut.clean(d("th[abbr='%s']" % name).next("td").text())
        s2 = ut.clean(d("th[abbr='%s']" % name).next("td").next("td").text())
        i1 = int(ut.clear_unit(s1))
        i2 = int(ut.clear_unit(s2))
        return str(i1+ i2)

    def get_join_pt_values(self, d, name):
        s1 = ut.clean(d("th[abbr='%s']" % name).next("td").next("td").next("td").text())
        s2 = ut.clean(d("th[abbr='%s']" % name).next("td").next("td").next("td").next("td").text())
        i1 = float(ut.clear_unit(s1))
        i2 = float(ut.clear_unit(s2))
        return str(i1+ i2)

    def setup(self):
        #基本情報
        self.header.append("事業所名")
        self.record.append(ut.req(self.get_name()))
        self.header.append("事業所番号")
        self.record.append(self.get_no())
        self.header.append("法人名")
        self.record.append(ut.req(self.get_company().strip()))
        self.header.append("TEL")
        tel = self.get_split(self.ds, '連絡先', 0).replace('Tel:','').replace('-','').replace('‐', '').replace("ー", "").replace("(", "").replace(")", "")
        if re.match(r"^\d+$", tel):
            self.record.append(ut.req(tel))
        else:
            print("電話番号が不正です。 -> " + tel)
            env.logging.warning("電話番号が不正です。 -> " + tel)
            self.record.append("")
        self.header.append("緊急電話対応")
        self.record.append(self.get_ari(self.dd, '緊急時の電話連絡の対応状況'))
        self.header.append("緊急電話番号")
        self.record.append(self.get(self.dd, "（その連絡先：電話番号）").replace('-','').replace('‐', '').replace("ー", ""))
        self.header.append("FAX")
        self.record.append(self.get_split(self.ds, '連絡先', 1).replace('Fax:','').replace('-','').replace('‐', '').replace("(", "").replace(")", ""))
        self.header.append("住所")
        self.record.append(ut.req(self.get_address()))
        geo = self.get_geocode()
#        geo = ["",""] 
        self.header.append("緯度")
        self.record.append(str(geo[0]))
        self.header.append("経度")
        self.record.append(str(geo[1]))
        self.header.append("HP_URL")
        self.record.append(self.get_hp() if self.get_hp() else "")
        self.header.append("代表者氏名")
        self.record.append(self.get_2_th(self.dd, "事業所の管理者の氏名及び職名", "氏名"))
        self.header.append("事業開始年月日")
        founding = pq(self.get(self.dd, "事業の開始（予定）年月日")).remove("div").text()
        founding = "".join([f if len(f) == 4 or len(f) == 2 else "0" + f for f in founding.split("/")])
        self.record.append(ut.req(founding))
        self.header.append("サービス提供地域")
        self.record.append("\r\n".join(self.fukuoka.services_in(self.get(self.ds, "サービス提供地域"))))
        self.header.append("サービス提供地域(備考)")
        self.record.append(self.get(self.ds, "サービス提供地域"))
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
        self.header.append("特別休暇")
        off_content1 = self.get(self.ds, "定休日")
        off_content2 = self.get(self.ds, "留意事項")
        self.record.append(off_content1 + "\r\n" + off_content2 if off_content2 else off_content1)
#
#        #ケアマネ情報
        self.header.append("ケアマネ一人当たりの担当利用者数")
        self.record.append(self.get_clear_unit(self.ds, "ケアマネジャー1人当たり担当利用者数"))
        self.header.append("ケアマネ数(常勤)")
        self.record.append(self.get_clear_unit(self.ds, "ケアマネジャー数"))
        self.header.append("ケアマネ数(非常勤)")
        self.record.append(self.get_pt_value(self.ds, "ケアマネジャー数"))
        self.header.append("主任ケアマネ数(常勤)")
        self.record.append(self.get_clear_unit(self.ds, "うち主任ケアマネジャー数"))
        self.header.append("主任ケアマネ数(非常勤)")
        self.record.append(self.get_pt_value(self.ds, "うち主任ケアマネジャー数"))
        self.header.append("経験年数5年以上のケアマネ割合")
        self.record.append(self.get_clear_unit(self.ds, "経験年数5年以上のケアマネジャーの割合"))
        self.header.append("男性ケアマネ数")
        self.record.append(self.get_clear_unit(self.dd, "男性"))
        self.header.append("女性ケアマネ数")
        self.record.append(self.get_clear_unit(self.dd, "女性"))
#
#        #有している資格
        self.header.append("医師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "医師")))
        self.header.append("医師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "医師")))

        self.header.append("歯科医師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "歯科医師")))
        self.header.append("歯科医師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "歯科医師")))

        self.header.append("薬剤師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "薬剤師")))
        self.header.append("薬剤師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "薬剤師")))

        self.header.append("保健師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "保健師")))
        self.header.append("保健師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "保健師")))

        self.header.append("助産師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "助産師")))
        self.header.append("助産師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "助産師")))

        self.header.append("看護師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "看護師")))
        self.header.append("看護師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "看護師")))

        self.header.append("准看護師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "准看護師")))
        self.header.append("准看護師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "准看護師")))

        self.header.append("理学療法士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "理学療法士")))
        self.header.append("理学療法士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "理学療法士")))

        self.header.append("作業療法士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "作業療法士")))
        self.header.append("作業療法士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "作業療法士")))

        self.header.append("言語聴覚士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "言語聴覚士")))
        self.header.append("言語聴覚士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "言語聴覚士")))

        self.header.append("社会福祉士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "社会福祉士")))
        self.header.append("社会福祉士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "社会福祉士")))

        self.header.append("介護福祉士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "介護福祉士")))
        self.header.append("介護福祉士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "介護福祉士")))

        self.header.append("実務者研修(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "実務者研修")))
        self.header.append("実務者研修(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "実務者研修")))

        self.header.append("介護職員基礎研修(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "介護職員基礎研修")))
        self.header.append("介護職員基礎研修(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "介護職員基礎研修")))

        self.header.append("視能訓練士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "視能訓練士")))
        self.header.append("視能訓練士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "視能訓練士")))

        self.header.append("義肢装具士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "義肢装具士")))
        self.header.append("義肢装具士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "義肢装具士")))

        self.header.append("歯科衛生士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "歯科衛生士")))
        self.header.append("歯科衛生士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "歯科衛生士")))

        self.header.append("あん摩マッサージ指圧師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "あん摩マッサージ指圧師")))
        self.header.append("あん摩マッサージ指圧師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "あん摩マッサージ指圧師")))

        self.header.append("はり師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "はり師")))
        self.header.append("はり師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "はり師")))

        self.header.append("きゅう師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "きゅう師")))
        self.header.append("きゅう師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "きゅう師")))

        self.header.append("柔道整復師(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "柔道整復師")))
        self.header.append("柔道整復師(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "柔道整復師")))

        self.header.append("栄養士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "栄養士")))
        self.header.append("栄養士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "栄養士")))

        self.header.append("管理栄養士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "管理栄養士")))
        self.header.append("管理栄養士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "管理栄養士")))

        self.header.append("精神保健福祉士(常勤)")
        self.record.append(ut.req(self.get_join_values(self.dd, "精神保健福祉士")))
        self.header.append("精神保健福祉士(非常勤)")
        self.record.append(ut.req(self.get_join_pt_values(self.dd, "精神保健福祉士")))
#
#        #介護報酬加算
        self.header.append("特定事業所加算（Ⅰ）")
        self.record.append(self.get_ari(self.ds, '特定事業所加算（Ⅰ）'))
        self.header.append("特定事業所加算（Ⅱ）")
        self.record.append(self.get_ari(self.ds, '特定事業所加算（Ⅱ）'))

        self.header.append("退院・退所加算")
        self.record.append(self.get_ari(self.ds, "退院・退所加算"))
        self.header.append("認知症加算")
        self.record.append(self.get_ari(self.ds, "認知症加算"))
        self.header.append("独居高齢者加算")
        self.record.append(self.get_ari(self.ds, "独居高齢者加算"))
        self.header.append("小規模多機能型居宅介護事業所連携加算")
        self.record.append(self.get_ari(self.ds, "小規模多機能型居宅介護事業所連携加算"))
        self.header.append("複合型サービス事業所連携加算")
        self.record.append(self.get_ari(self.ds, "複合型サービス事業所連携加算"))
        self.header.append("緊急時等居宅カンファレンス加算")
        self.record.append(self.get_ari(self.ds, "緊急時等居宅カンファレンス加算"))

        self.header.append("入院時情報提供加算（Ⅰ）")
        self.record.append(self.get_ari(self.ds, "入院時情報提供加算（Ⅰ）"))
        self.header.append("入院時情報提供加算（Ⅱ）")
        self.record.append(self.get_ari(self.ds, "入院時情報提供加算（Ⅱ）"))
