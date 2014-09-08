#encoding is utf-8
import Image
import ImageTk
import Tkinter
import os
import shutil
import sys
from tkFileDialog import askdirectory
from operator import itemgetter


def resize():
    shrinkFactor = 4
    jpgQuality = qualitySlider.get()
    i = 0
    for filename in os.listdir(inputDirectory):
        im = Image.open(inputDirectory + filename)
        targetDimensions = tuple(x/shrinkFactor for x in im.size)
        smaller = im.resize(targetDimensions,Image.ANTIALIAS)

        smaller.save(outputDirectory + filename,'JPEG',quality=jpgQuality)


def resizeToPng():
    shrinkFactor = 4
    jpgQuality = qualitySlider.get()
    i = 0
    for filename in os.listdir(inputDirectory):
        im = Image.open(inputDirectory + filename)
        targetDimensions = tuple(x/shrinkFactor for x in im.size)
        smaller = im.resize(targetDimensions,Image.ANTIALIAS)
        outputFilename = filename.replace(".jpg",".png")

        smaller.save(outputDirectory + outputFilename,'PNG',quality=jpgQuality)

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
        displayCheck = Tkinter.IntVar()
        captions.append((caption,filename,(x,y),displayCheck))
        textInput = Tkinter.Entry(imageFrame,textvariable=caption)
        textInput.pack()

        Tkinter.Checkbutton(imageFrame,text="omake",variable=displayCheck).pack()

        imageFrame.pack(side=Tkinter.LEFT)
        

    button = Tkinter.Button(root, text = "Submit", command = submit)
    button.pack(side=Tkinter.BOTTOM)

    root.wait_window()
    
    return captions,title
    

def generateImageDivs(captions):
    imageDivs = ""
    divTemplate = file("imageDiv.html").read()
    i = 1
    for image in captions:
        (caption,filename,(x,y),displayCheckbox) = image
        extension = filename.split(".")[1]
        divText = divTemplate.replace("##IMAGE_CAPTION##",caption.get())
        divText = divText.replace("##IMAGE_FILE_NAME##","ph"+str(i)+"."+extension)
        divText = divText.replace("##X##","660")
        divText = divText.replace("##Y##",str(calculateWidth(x,y)))
        imageDivs = imageDivs +"\n\n"+ divText
        i = i +1
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
    
    (caption,filename,(x,y),displayCheck) = mainImage
    filename, extension= filename.split(".")
    shutil.copyfile(outputDirectory + filename+"."+extension,"./img/main."+extension) 


    template = file("template.html").read()
    index = template.replace("##TITLE##",title.get().encode('utf-8'))
    index = index.replace("##MAIN_CAPTION##",caption.get().encode('utf-8'))
    index = index.replace("##MAIN_FILENAME##","main."+extension)


    displayImages = []
    omakeImages = []
    for image in captions:
        (caption,filename,(x,y),displayCheck) = image
        if displayCheck.get() == 0:
             displayImages.append(image)
        else:
            omakeImages.append(image)
   
    imageDivs = generateImageDivs(displayImages)
    index = index.replace("##IMAGES##",imageDivs.encode('utf-8'))

    #save files in new order
    outputImages = displayImages + omakeImages

    i=1
    for image in outputImages:
        (caption,filename,(x,y),displayCheck) = image
        src = outputDirectory + filename
        dest = "./img/"+ "ph" +str(i) + "."+extension
        shutil.copyfile(src,dest)
        i = i+1

    try:
        f = open('index.html', 'w')
        f.write(index)
    finally:
        f.close()
        

def makeEntry(parent, caption, width=None, **options):
    Tkinter.Label(parent, text=caption).pack(side=Tkinter.LEFT)
    entry = Tkinter.Entry(parent, **options)
    if width:
        entry.config(width=width)
    entry.pack(side=Tkinter.LEFT)
    return entry





if __name__ == "__main__":

    mainGui = Tkinter.Tk()

    Tkinter.Label(mainGui,text="Quality").pack()
    qualitySlider = Tkinter.Scale(mainGui, from_=1, to=100,orient=Tkinter.HORIZONTAL)
    qualitySlider.set(90)
    qualitySlider.pack()
    
    button = Tkinter.Button(mainGui, text = "Resize files to JPG", command = resize)
    button.pack()



    button = Tkinter.Button(mainGui, text = "Resize files to PNG", command = resizeToPng)
    button.pack()

    button = Tkinter.Button(mainGui, text = "Create HTML", command = createFiles )
    button.pack()


    mainGui.mainloop()
    
    sys.exit()

            
