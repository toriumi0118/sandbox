#! /bin/env python
#! -*- coding: utf-8 -*-
"""入力された事業所番号一覧からwamnetの情報を取得します
"""

import sys
import csv
import codecs
import logging
import env
from office import Office
from kyotaku import Kyotaku

def re_create(no, clazz, vCd):
    for nendo in ['2013','2012','2011','2010']:
        try:
            return clazz(nendo, vCd, no, '40')
        except:
            print("事業者番号%s(%s) は存在しません。" % (no, nendo))
    return None


def main():
    if len(sys.argv) == 1:
        print("Usage: {} input.csv [DAY|KYOTAKU]".format(sys.argv[0]))
        exit()
    if len(sys.argv) < 2:
        print("input fileを引数に渡してください")
        exit()
    if len(sys.argv) < 3 or sys.argv[2] not in ["DAY", "KYOTAKU"]:
        print("事業所区分を入力してください。(DAY, KYOTAKU)")
        exit()

    print('start load %s.' % sys.argv[1])
    arg = open(sys.argv[1], "r")

    filename = env.output_dir + env.date_str + '-output.csv'
    urls = open(env.output_dir + env.date_str + '-urls.csv', "w", encoding="utf-8")

    with open(filename, 'w', newline='', encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile,  delimiter=',')
        ignore = []

        cnt = 0
        skip = 0
        header = True
        lines = arg.readlines()
        for line in lines:
            no = line.rstrip("\r").rstrip("\n")
            cnt += 1
            print("%d/%d in process. (%s)" % (cnt, len(lines), no))
            env.logging.info("事業者番号 : " + no + " のクローリングを開始します")
            if no in ["4071403440"]:
                print('%sは重複して事業所が登録されているのが目視で確認されたのでskipします。' % no)
                env.logging.warning('%sは重複して事業所が登録されているのが目視で確認されたのでskipします。' % no)
                skip += 1
                continue
            if sys.argv[2] == "DAY":
                office = re_create(no, Office, "006")
            elif sys.argv[2] == "KYOTAKU":
                office = re_create(no, Kyotaku, "023")
            if not office:
                env.logging.warn("事業所番号 : " + no + " は存在しません")
                ignore.append([no + "(存在しない可能性があります。要確認)"])
                continue
            office.setup()
            if header:
                writer.writerow(office.header)
                header = False
            writer.writerow(office.record)
            urls.write(office.url() + "\n")
            env.logging.info("事業者番号 : " + no + " のクローリングを終了します")
        writer.writerows(ignore)
    urls.close()
    csvfile.close()
    print("finish!! (%s) | total %d, skipped %d." % (filename, cnt, skip))

if __name__ == '__main__':
    main()
