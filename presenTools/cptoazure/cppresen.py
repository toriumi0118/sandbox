# coding:utf-8

import sys, os, re
from azure.storage import BlobService

if len(sys.argv) != 3:
    print("Usage : # python %s [sb_id] [presen_home_path]" % sys.argv[0])
    quit()

id = sys.argv[1]
presen_path = sys.argv[2]

print("-----------------------")
print("start cp data.")
print("-----------------------")
print("")
print("config ----------------")
print("sb_id: '%s'" % id)
print("presen_home_path: '%s'" % presen_path)
print("-----------------------")

if not os.path.exists(presen_path): raise IOError(presen_path + "が見つかりません")
if not os.path.exists(os.path.join(presen_path, "img")): raise IOError("imgディレクトリが見つかりません")
if not os.path.exists(os.path.join(presen_path, "css")): raise IOError("cssディレクトリが見つかりません")

for dirpath, dirnames, filenames in os.walk(presen_path):
    for filename in filenames:
        targetfile = os.path.join(dirpath, filename)
        if ".gitignore" in targetfile: continue
        blobname = re.sub(presen_path + r"\\", \
          "servicebuilding/servicebuilding%s/presentation/" % id, \
          targetfile)\
          .replace("\\", "/")

        print("%s -> %s" % (targetfile, blobname), end="")
        try:
            blob_service = BlobService(\
              "welmokpilog",\
              "=LfXCQBPcj4u313vfz+mx+pGC2fWwnhAo+2UW5SVAnAqIjYBEPt76oievOM3LpV35BwYCYi6ufeSBRZCs/h3c8Q==")
            blob_service.put_block_blob_from_path(\
              "test-data-resources",\
              blobname,\
              targetfile)
        except:
            print("    [ERROR]")
            print("Unexpected error : ", sys.exc_info()[0])
            raise
        print("    [SUCCEED]")
print("finish move data.")
