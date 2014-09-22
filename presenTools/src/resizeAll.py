#resize whole directory script
#Use on the data directory copied from central server

import os
import re
import Image
import fileinput

imageRegex = re.compile(".*?\.png$")
presenRegex = re.compile(".*?\.htm$")

PATH = "C:\\path\\to\\data\\files"

paths = os.walk(PATH)

#(path, subdirectories, files)

        
def resize(filepath):
    jpgQuality = 90
    im = Image.open(filepath)
    im.save(filepath[:-3]+"jpg",'JPEG',quality=jpgQuality)

def resizeAllFiles():
    for triplet in paths:
        (directory,folders,filenames) = triplet
        for filename in filenames:
            fullPath = directory + os.sep + filename
            stats = os.stat(fullPath)
            size = stats.st_size
            if size > 100000 and imageRegex.match(filename):
                resize(fullPath)
                os.remove(fullPath)
                print fullPath

def rewriteHtml():
    for triplet in paths:
        (directory,folders,filenames) = triplet
        for filename in filenames:
            fullPath = directory + os.sep + filename
            if presenRegex.match(filename):
                #Use fileinput library to edit in place
                htmlFile = fileinput.input(fullPath,inplace=True) 
                for line in htmlFile:
                    newline = line.replace("main.png","main.jpg")
                    print re.sub(r"ph(\d+)\.png","ph\g<1>.jpg",newline)
                print fullPath
        

