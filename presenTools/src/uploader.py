# This Python file uses the following encoding: utf-8
from Tkinter import *
import paramiko
import tkMessageBox
import os

cssDir = "./css/"
imgDir = "./img/"

officesDir = "/home/wellmotion/centralserver/data/office/"

mainGui = Tk()

serverAddress = StringVar()
serverPort = StringVar()
serverUsername = StringVar()
serverPassword = StringVar()

databaseUser = StringVar()
databaseName = StringVar()
databasePassword = StringVar()


serverAddress.set('133.242.18.214')
serverPort.set('54649')
serverUsername.set('wellmotion')
serverPassword.set('')

databaseUser.set("root")
databaseName.set("dev")
databasePassword.set("")




uploaderName = "presen_tool"



def getConnection():
    
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(serverAddress.get(),
                int(serverPort.get()),
                username=serverUsername.get(),
                password=serverPassword.get(),
                key_filename='./presen_key')
    return ssh
    

def upload():
    if not areYouSure():
        return
    oid = int(officeId.get())

    officeDir = officesDir + ("office%d" % oid)

    uploadDir = officesDir + ("office%d/presentation/" % oid)
    
    ssh = getConnection()
    
    stdin, stdout, stderr = ssh.exec_command("mkdir -p %s" % uploadDir)
    type(stdin)
    if stdout.read():
        tkMessageBox.showerror("Error","Problem making new folder")
        
    stdin, stdout, stderr = ssh.exec_command("mkdir -p %s" % uploadDir + "css")
    type(stdin)
    if stdout.read():
        tkMessageBox.showerror("Error","Problem making new folder")

    stdin, stdout, stderr = ssh.exec_command("mkdir -p %s" % uploadDir + "img")
    type(stdin)
    if stdout.read():
        tkMessageBox.showerror("Error","Problem making new folder")


    ftp = ssh.open_sftp()
        
    for filename in os.listdir(cssDir):
        localFile = cssDir + filename
        remoteFile = uploadDir+ "css/" + filename
        ftp.put(localFile, remoteFile)

    for filename in os.listdir(imgDir):
        localFile = imgDir + filename
        remoteFile = uploadDir +"img/" +filename
        ftp.put(localFile, remoteFile)

    ftp.put("./index.html",uploadDir+"index.html")
    ftp.close()

    stdin, stdout, stderr = ssh.exec_command("chmod 755 -R %s" % officeDir)
    type(stdin)

    #stdin, stdout, stderr = ssh.exec_command('mysql -u %s -p %s -e "INSERT INTO office_presentation_history (office_id, editor, action) value (%d, \'%s\', \'UPDATE\' )"' % (databaseUser.get(),databaseName.get(),oid,uploaderName))
    #type(stdin)
    #stdin.write(databasePassword.get() + "\n")
    #stdin.flush()

    
    ssh.close()



def delete():
    if not areYouSure():
        return
    ssh = getConnection()
    
    oid = int(officeId.get())
    uploadDir = officesDir + ("office%d" % oid)
    stdin, stdout, stderr = ssh.exec_command("rm -rf %s" % uploadDir)
    type(stdin)
    if stdout.read():
        tkMessageBox.showerror("Error","Problem Deleting Files")


    #stdin, stdout, stderr = ssh.exec_command('mysql -u %s -p %s -e "INSERT INTO office_presentation_history (office_id, editor, action) value (%d, \'%s\', \'DELETE\' )"' % (databaseUser.get(),databaseName.get(),oid,uploaderName))
    #type(stdin)
    #stdin.write(databasePassword.get() + "\n")
    #stdin.flush()
    return

    
    
    
def areYouSure():
    officeName = getOfficeNameFromServer()
    return tkMessageBox.askyesno("Upload To Server","Editing the following office:\n\n" + officeName + "\n\nAre you sure?")


def getOfficeNameFromServer():
    ssh = getConnection()

    oid= int(officeId.get())
    
    stdin, stdout, stderr = ssh.exec_command('mysql -u %s -p %s -e "SELECT office_id, name FROM office WHERE office_id in (%d,%d)"' % (databaseUser.get(),databaseName.get(),oid,oid))
    type(stdin)
    stdin.write(databasePassword.get() + "\n")
    stdin.flush()

    officeName = stdout.read()
    ssh.close()
    return officeName




def checkOfficeName():
    officeName = getOfficeNameFromServer()
    tkMessageBox.showinfo("Office ID",officeName)
    


f = Frame()
Label(f,text="office_id").pack(side=LEFT)
officeId = Entry(f)
officeId.pack(side=LEFT)
f.pack()



button = Button(mainGui, text = "Check Office Name", command = checkOfficeName)
button.pack(fill=BOTH)

button = Button(mainGui, text = "Upload Files to Server", command = upload)
button.pack(fill=BOTH)

button = Button(mainGui, text = "Delete Files from Server", command = delete)
button.pack(fill=BOTH)

separator = Frame(height=2, bd=1, relief=SUNKEN)
separator.pack(fill=X, padx=5, pady=5)

Label(text="Settings").pack()

separator = Frame(height=2, bd=1, relief=SUNKEN)
separator.pack(fill=X, padx=5, pady=5)

f = Frame()
Label(f,text="Server Address").pack(side=LEFT)
serverAddressEntry = Entry(f,textvariable=serverAddress)
serverAddressEntry.pack(side=LEFT)
f.pack()

f = Frame()
Label(f,text="Server Port").pack(side=LEFT)
serverPortEntry = Entry(f,textvariable=serverPort)
serverPortEntry.pack(side=LEFT)
f.pack()

f = Frame()
Label(f,text="Server Username").pack(side=LEFT)
serverUsernameEntry = Entry(f,textvariable=serverUsername)
serverUsernameEntry.pack(side=LEFT)
f.pack()

f = Frame()
Label(f,text="Private Key Password").pack(side=LEFT)
serverPasswordEntry = Entry(f,textvariable=serverPassword,show="*")
serverPasswordEntry.pack(side=LEFT)
f.pack()

separator = Frame(height=2, bd=1, relief=SUNKEN)
separator.pack(fill=X, padx=5, pady=5)

f = Frame()
Label(f,text="Database User").pack(side=LEFT)
databaseUserEntry = Entry(f,textvariable=databaseUser)
databaseUserEntry.pack(side=LEFT)
f.pack()

f = Frame()
Label(f,text="Database Name").pack(side=LEFT)
databaseNameEntry = Entry(f,textvariable=databaseName)
databaseNameEntry.pack(side=LEFT)
f.pack()

f = Frame()
Label(f,text="Database Password").pack(side=LEFT)
databasePasswordEntry = Entry(f,textvariable=databasePassword,show="*")
databasePasswordEntry.pack(side=LEFT)
f.pack()





mainGui.mainloop()

sys.exit()



