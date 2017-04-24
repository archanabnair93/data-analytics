from Tkinter import *
import tkMessageBox
class myApp(Frame):


    def __init__(self, parent):
        Frame.__init__(self, parent)
        self.parent=parent
        self.initUI()

    def initUI(self):


        # Prompt User to select from three classes
        l = Label(self, text="Select Class:", width=75, anchor='center')
        l.pack()



        #Display the classes as Radiobuttons

        var = StringVar()
        R1 = Radiobutton(self, text="Grade 6", variable=var, value="Grade 6",
                         )

        R1.pack()

        R2 = Radiobutton(self, text="Grade 7", variable=var, value="Grade 7",
                     )
        R2.pack()

        R3 = Radiobutton(self, text="Grade 8", variable=var, value="Grade 8",
                     )
        R3.pack()

        #Displays the class report for the selected grade

        def viewreport():
         if var.get() == "Grade 6":
            l6 = Label(self, text="Class Profile for Grade 6", width=75, anchor='center')
            l6.pack()
            l2 = Label(self, text="Average Marks : 585", width=75, anchor='center')
            l2.pack()

            l2 = Label(self, text="Rank: 7", width=75, anchor='center')
            l2.pack()

            # Determine based on rules(that are outside the scope of this project)
            # if the selected class qualifies for consideration in the Performance Evaluation
            # of the institution

            C1 = Checkbutton(self, text="Check if Class Qualifies", onvalue=1, width=20, pady=10)
            C1.pack()

            l5 = Label(self, text="Remarks:", width=75, anchor='center')
            l5.pack()

            E1 = Entry(self, bd=5)
            E1.pack()

         if var.get() == "Grade 7":
             l7 = Label(self, text="Class Profile for Grade 7", width=75, anchor='center')
             l7.pack()

             l3 = Label(self, text="Average Marks :  685", width=75, anchor='center')
             l3.pack()

             l3 = Label(self, text="Rank: 5", width=75, anchor='center')
             l3.pack()

             C2 = Checkbutton(self, text="Check if Class Qualifies", onvalue=1, width=20, pady=10)
             C2.pack()

             l5 = Label(self, text="Remarks:", width=75, anchor='center')
             l5.pack()

             E2 = Entry(self, bd=5)
             E2.pack()

         if var.get() == "Grade 8":
             l8 = Label(self, text="Class Profile for Grade 8", width=75, anchor='center')
             l8.pack()

             l4 = Label(self, text="Average Marks:  785", width=75, anchor='center')
             l4.pack()

             l4 = Label(self, text="Rank: 3", width=75, anchor='center')
             l4.pack()

             C3 = Checkbutton(self, text="Check if Class Qualifies", onvalue=1, width=20, pady=10)
             C3.pack()

             l5 = Label(self, text="Remarks:", width=75, anchor='center')
             l5.pack()

             E3 = Entry(self, bd=5)
             E3.pack()


         button = Button(self, text='Submit', command=self.reply,pady=5)
         button.pack()

        #Display button to View Report after selecting Grade

        button = Button(self, text='View Report', command=viewreport)
        button.pack()


    def reply(self):
         tkMessageBox.showinfo(title='popup', message='Details Submitted!')
         self.quit()

if __name__ == '__main__':
    root=myApp(None)
    root.pack()
    root.mainloop()



