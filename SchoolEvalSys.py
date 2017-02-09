from tkinter import *
import tkinter.messagebox
from queue import Queue
from threading import Thread
import time
from urllib.request import urlopen
import webbrowser
from multiprocessing import Process
import os

#Welcomes the user to the platform by introducing itself on the console, and waiting for 5 seconds before opening the application

print("Welcome to the Reporting Tool. You will be redirected to the application in 5 seconds.")
time.sleep(5)

#function definition for displaying the process details

def processinfo(title):
    print(title)
    print('Process name:', __name__)
    print('Parent process:', os.getppid())
    print('Process id:', os.getpid())

def f(name):
    processinfo('Reporting Tool Process Details:')
    print('Thanks. The process is complete,', name)



#function to open the specified URL

def get_url(a_queue, a_url):

    a_queue.put(urlopen(a_url).read())



class myApp(Frame):


    def __init__(self, parent):
        Frame.__init__(self, parent)
        self.parent=parent
        self.initUI()

    def view_report(self):
        url_list = ["http://mmcs.edu.in/report1.html", "http://mmcs.edu.in/report2.html"]
        # The content of the first URL in url_list is on the monitor
        url_queue = Queue()

        for url in url_list:
            thread = Thread(target=get_url, args=(url_queue, url))
            thread.start()
            webbrowser.open_new(url)

    def initUI(self):


        #Introduces the user to the reporting tool
        l = Label(self, text="Welcome to the Institution Reporting Tool. Click 'View report' ", width=75, anchor='center')
        l.pack()
        button = Button(self, text='View Report', command=self.reply)
        button.pack()
        button = Button(self, text='Quit Application', command=self.quitApp)
        button.pack()

    def reply(self):
         tkinter.messagebox.showinfo(title='popup', message='You are now leaving the application and will be redirected to your default Web browser!')
         self.view_report()

    def quitApp(self):
        tkinter.messagebox.showinfo(title='popup',message='Thanks for using the application!')

        self.quit()



if __name__ == '__main__':
    p = Process(target=f, args=('Admin',))
    p.start()
    p.join()
    root=myApp(None)
    root.pack()
    root.mainloop()



