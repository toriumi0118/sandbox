import Image
import ImageTk
import Tkinter
import os
import shutil
import sys
from tkFileDialog import askdirectory


def resize():
    shrinkFactor = 4
    jpgQuality = 90
    i = 0
    for filename in os.listdir(inputDirectory):
        im = Image.open(inputDirectory + filename)
        targetDimensions = tuple(x/shrinkFactor for x in im.size)
        smaller = im.resize(targetDimensions,Image.ANTIALIAS)
        if i == 0:
            smaller.save(outputDirectory + "main.jpg",'JPEG',quality=jpgQuality)
        else:
            smaller.save(outputDirectory + "ph"+str(i)+".jpg",'JPEG',quality=jpgQuality)
        i = i+1

def getCaptions():
    files = os.listdir(outputDirectory)
    captions = []
    images = []
    root = Tkinter.Toplevel()

    def submit():
        root.destroy()
        return

    title = Tkinter.StringVar()
    titleInput = Tkinter.Entry(root,textvariable=title)
    titleInput.insert(0, "Page Title")
    titleInput.pack()

    label = Tkinter.Label(root)
    label.pack()

    for filename in files:
        im = Image.open(outputDirectory + filename)
        (x,y) = im.size
        (thumbX,thumbY) = (x/10,y/10)
        thumbnail = im.resize((thumbX,thumbY),Image.ANTIALIAS)
        displayThumb = ImageTk.PhotoImage(thumbnail)

        imageFrame = Tkinter.Frame(root)
        
        
        label = Tkinter.Label(imageFrame,image=displayThumb)
        label.image = displayThumb
        label.pack()
        
        caption = Tkinter.StringVar()
        captions.append((caption,filename,(x,y)))
        textInput = Tkinter.Entry(imageFrame,textvariable=caption)
        textInput.pack()

        imageFrame.pack(side=Tkinter.LEFT)
        

    button = Tkinter.Button(root, text = "Submit", command = submit)
    button.pack(side=Tkinter.BOTTOM)

    root.wait_window()
    
    return captions,title
    

def generateImageDivs(captions):
    imageDivs = ""
    divTemplate = file("imageDiv.html").read()
    for image in captions:
        (caption,filename,(x,y)) = image
        divText = divTemplate.replace("##IMAGE_CAPTION##",caption.get())
        divText = divText.replace("##IMAGE_FILE_NAME##",filename)
        divText = divText.replace("##X##","660")
        divText = divText.replace("##Y##",str(calculateWidth(x,y)))
        imageDivs = imageDivs +"\n\n"+ divText
    return imageDivs

def calculateWidth(x,y):
    if x>y:
        return 495
    else:
        return 880

#resize images in subfolder
inputDirectory = "./inputImages/"
outputDirectory = "./outputImages/"
##inputDirectory = askdirectory()
imageCaptions =[]


def createFiles():
    captions,title = getCaptions()
    captions.reverse()
    mainImage = captions.pop()
    captions.reverse()
    
    (caption,filename,(x,y)) = mainImage

    template = file("template.html").read()
    index = template.replace("##TITLE##",title.get().encode('utf-8'))
    index = index.replace("##MAIN_CAPTION##",caption.get().encode('utf-8'))
    index = index.replace("##MAIN_FILENAME##",filename)
    imageDivs = generateImageDivs(captions)
    index = index.replace("##IMAGES##",imageDivs.encode('utf-8'))

    try:
        f = open('index.html', 'w')
        f.write(index)
    finally:
        f.close()
        
    for filename in os.listdir(outputDirectory):
        shutil.copy(outputDirectory+filename,"./img")
        

def makeEntry(parent, caption, width=None, **options):
    Tkinter.Label(parent, text=caption).pack(side=Tkinter.LEFT)
    entry = Tkinter.Entry(parent, **options)
    if width:
        entry.config(width=width)
    entry.pack(side=Tkinter.LEFT)
    return entry



def gui():
    mainGui = Tkinter.Tk()

    button = Tkinter.Button(mainGui, text = "Resize files", command = resize)
    button.pack()

    button = Tkinter.Button(mainGui, text = "Create HTML", command = createFiles )
    button.pack()

    mainGui.mainloop()

if __name__ == "__main__":
    gui()
    sys.exit()

            
