#! /bin/env python
#! coding: utf-8
"""入力された事業所番号csvファイルとDB内の事業所番号を比較し
   DBに登録がない事業所番号を一覧で返す
"""
import os
import json
import pymysql
import env
import sys

def main():
    if len(sys.argv) == 1:
        print("Usage: {} office_numbers.csv output.csv [DAY|KYOTAKU]".format(sys.argv[0]))
        exit()
    if len(sys.argv) < 2:
        print("wamnetから取得した全事業所番号が記載されているファイル名を入力してください")
        exit()
    if len(sys.argv) < 3:
        print("DB内に存在しない事業所番号一覧を出力するファイル名を入力してください。")
        exit()
    if len(sys.argv) < 4 or sys.argv[3] not in ["DAY", "KYOTAKU"]:
        print("ターゲットとする事業所区分を指定してください。(DAY, KYOTAKU)")
        exit()
    
    db_no = db_office_numbers(sys.argv[3])
    file_no = no_in_file(sys.argv[1])

    out = open(sys.argv[2], "w")
    for no in file_no:
        int_no = int(no)
        if int_no in db_no:
            continue
        out.write(no)
        no_str = no.strip()
        env.logging.info(no_str + "　はDBに存在しません")
        print(no_str + "　はDBに存在しません")
    out.close()

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
    
def no_in_file(s):
    f = open(s, "r")
    return list(f)

if __name__ == '__main__':
    main()
