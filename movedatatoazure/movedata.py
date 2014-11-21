# coding:utf-8

import sys, os, re
from azure.storage import BlobService

if len(sys.argv) != 2:
    print("Usage : # python %s data_directory" % sys.argv[0])
    quit()

data_directory = sys.argv[1]

print("start move data.")
print("top directory is '%s'." % data_directory)

for dirpath, dirnames, filenames in os.walk(data_directory):
    for filename in filenames:
        targetfile = os.path.join(dirpath, filename)
        if ".gitignore" in targetfile: continue

        blobname = re.sub(r".*\\centralserver\\data\\", "", targetfile).replace("\\", "/")
        print("upload %s -> %s" % (blobname, targetfile), end="")
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
