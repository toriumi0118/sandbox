#! /bin/env python
#! coding: utf-8
"""入力されたオープンデータcsvファイルの事業所番号とDB内の事業所番号を比較し
   DBに登録がない事業所番号と付随する情報（住所など）を一覧で返す
"""
import os
import json
import pymysql
import env
import sys
import csv
from pygeocoder import Geocoder

def main():
    if len(sys.argv) == 1:
        print("Usage: {} opendata_office.csv output.csv [DAY|KYOTAKU]".format(sys.argv[0]))
        exit()
    if len(sys.argv) < 2:
        print("Usage: {} opendata_office.csv output.csv [DAY|KYOTAKU]".format(sys.argv[0]))
        exit()
    if len(sys.argv) < 3:
        print("Usage: {} opendata_office.csv output.csv [DAY|KYOTAKU]".format(sys.argv[0]))
        exit()
    if len(sys.argv) < 4 or sys.argv[3] not in ["DAY", "KYOTAKU"]:
        print("Usage: {} opendata_office.csv output.csv [DAY|KYOTAKU]".format(sys.argv[0]))
        exit()
    
    db_no = db_office_numbers(sys.argv[3])
    od = opendata(sys.argv[1])

    out = csv.writer(open(sys.argv[2], "w", encoding="utf-8"), lineterminator="\n")
    for data in od[1:]:
        data[2] = data[2].strip()
        int_no = int(data[2])
        if int_no in db_no:
            continue
        address = data[4][7:].replace("\r","").replace("\n","")
        geo = geocode("福岡県" + address)
        data.append(geo[0])
        data.append(geo[1])
        data[4] = address.replace("福岡市", "")
        data[5] = data[5].replace("-","")
        out.writerow(data)
        env.logging.info(data[2] + "(" + data[3] + ")はDBに存在しません")
        print(data[2] + "(" + data[3] + ")はDBに存在しません")

def db_office_numbers(kind):
    fname = os.path.join(os.path.dirname(__file__), "database.json")
    with open(fname) as f:
        database = json.load(f)

    con = pymysql.connect(**database)
    cur = con.cursor()
    if kind == "DAY":
        cur.execute("SELECT name, office_no FROM office")
    elif kind =="KYOTAKU":
        cur.execute("SELECT name, office_no FROM kyotaku")
    else:
        raise ValueError("[DAY|KYTOAKU] is required")        

    db_file = open(env.output_dir + env.date_str + "-db_no.txt", "w")
    db_no = []
    for r in cur.fetchall():
        if r[1]:
            db_no.append(int(r[1]))
            db_file.write(r[1] + "\n")
        else:
            s = r[0] + "は事業所番号が設定されていません"
            print(s)
            env.logging.error(s)
            db_file.write(s + "\n")
    con.close()
    db_file.close()
    return db_no
    
def opendata(fname):
    l = []
    with open(fname, "r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for row in reader:
            l.append(row) 
    return l 

def geocode(address):
    try:
        return Geocoder.geocode("福岡県" + address)[0].coordinates
    except:
        rep = re.match(r"((.+-\d+)|(.+\d+号))", ad).group()
        print('%sのgeocodeが見つかりませんでした。調整します。→%s' % (ad, rep))
        return Geocoder.geocode("福岡県" + rep)[0].coordinates

if __name__ == '__main__':
    main()
