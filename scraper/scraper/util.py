## Helpful functions to aid crawling

import requests
import re

def getTextById(tree,id):
    idString = "diff-c" + str(id)
    field = tree.find(diffid=idString)
    if field:
        return field.text 


def getAttributeValueById(tree,id,attribute):
    idString = "diff-c" + str(id)
    field = tree.find(diffid=idString)
    if field:
        return field.get(attribute)

def getStartUrls(facilityType):
    results =[]

    cityCds = [401374,401366,401331,401358,401323,401315,401340]
    for cityCd in cityCds:
        n=0
        while True:
            payload = {"PrefCd" : "40",
               "ServiceCd" : str(facilityType),
               "JShikuchosonCd" : str(cityCd),
               "method" : "result",
               "action_kouhyou_pref_search_list_list" : "true",
               "p_offset" : str(n*5),
               "p_count" : "5",      ## Changing p_count appears not to work
               "p_order_name" : "0",
               "p_sort_name" : "36"}
            n = n+1

            ## Search results for Fukuoka Prefecture
            page = requests.post("http://www.kaigokensaku.jp/40/index.php?action_kouhyou_pref_search_list_list=true&PrefCd=40",
                          data=payload)

            regex = re.compile(r"""\'url\'\:\'index.php\?action_kouhyou_detail_([0-9]+)_([0-9]+)+_kani=true\&amp\;JigyosyoCd=(.*?)\&amp\;PrefCd=40&amp\;VersionCd=([0-9]+)""")

            if not regex.findall(page.text): ## End of search results
                break

            for regexMatch in regex.findall(page.text):
                (year,versionCd1,jigyosyoCd,versionCd2) = regexMatch
                url = "http://www.kaigokensaku.jp/40/index.php?action_kouhyou_detail_"+year+"_"+versionCd1+"_kani=true&JigyosyoCd="+jigyosyoCd+"&PrefCd=40&VersionCd="+versionCd2
                results.append(url)

    return tuple(set(results)) ## convert to set to remove duplicates