 import Tkinter as tk
import tkMessageBox
class SubjectApp(tk.Tk):
    def __init__(self):
        tk.Tk.__init__(self)
        # Displayed instruction to enter input, obtained user input and button clicked for performing action
        self.input_label = tk.Label(self, text="Enter New Elective")
        self.input_entry = tk.Entry(self, width=10)
        self.add_button = tk.Button(self, text="Add Elective", command=self.on_add_button)
        # Elements aligned
        self.input_label.grid(row=1, column=3)
        self.input_entry.grid(row=2, column=3)
        self.add_button.grid(row=3, column=3)


    def on_add_button(self):
        # Stored the user input in variable 'text'
        text=self.input_entry.get()
        
        # Created set to store the valid subjects
        subjectset = set(["German", "Spanish", "Latin"])
        
        # Validated user input
        # Stored the subject details in dictionary 'dict' and retrieved data for "class" and "type"
        # Called function to list the current subjects
        if text in subjectset:
            dict = {'Class': '8', 'Type': 'Language'};
            
            name = tk.StringVar()
            name.set(dict['Class'])
            displayname_label = tk.Label(self, text="Class:")
            name1 = tk.Label(self, textvariable=name)
            
            subtype = tk.StringVar()
            subtype.set(dict['Type'])
            name2_label = tk.Label(self, text="Type:")
            name2 = tk.Label(self, textvariable=subtype)
            
            old_elective_label = tk.Label(self, text="Old Subjects List:")
            
            self.show_current()
            
            # Elements Aligned
            displayname_label.grid(column=2, row=4)
            name1.grid(column=3, row=4)
            name2_label.grid(column=2, row=5)
            name2.grid(column=3, row=5)
            old_elective_label.grid(column=3, row=8)
        # Alert box displayed if the user input is incorrect, i.e, not present in set s    
        else:
            self.reply()

    # Function to view the intial stack contents
    def view_stack(self):
        subjects = ["Science", "Math", "English"]
        return subjects

    # Function to display the current stack
    def show_current(self):
        v = tk.StringVar()
        var = tk.StringVar()
        subjects=self.view_stack()
        sub_list = tk.Label(self, textvariable=v)

        item = " ".join(subjects)
        v.set(item)
        self.newsubjects =subjects
        self.view_all_button = tk.Label(self, text='New Subject List:')
        self.replace_subject(subjects)

        sub_list.grid(column=3, row=9)
        self.view_all_button.grid(column=3, row=14)

    # Function to replace the subject in the stack
    def replace_subject(self, subjects):
        var=tk.StringVar()
        subjects = self.view_stack()
        subjects.pop()
        subjects.append(self.input_entry.get())
        sub_list1 = tk.Label(self, textvariable=var)
        sub_list1.grid(column=3, row=15)
        item = " ".join(subjects)
        var.set(item)

    # Function to display the alert box if the user input is invalid
    def reply(self):
        tkMessageBox.showinfo(title='popup', message='Incorrect Elective!')
        quit()




app = SubjectApp()
app.mainloop()
