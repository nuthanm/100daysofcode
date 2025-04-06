## Learnt the following concepts in python
✅ Declaring variables - Simple and Array
~~~
Simple variable:
dayBegin = 1

Array Variable:
subFolders = ["C-Sharp", "Python", "PowerShell"]
~~~
✅ Looping from day 1 to 5 (5 can change to any value)
~~~
Reason of endNumber + 1, 1 to 5 means it creates only 4 folders but our expectation is 5.
for i in range(beginNumber, endNumber + 1):
  print(f"Day {i}")

~~~
✅ Creating folders and subfolders - I used _**pathlib**_ library, we can make use of _**Os**_ library as well.
~~~
  Works for any folder
  Option 1:
      if not sub_folder_path.exists():
         sub_folder_path.mkdir(parents=True)

  Option 2:
     sub_folder_path.mkdir(parents=True, exist_ok = True)
~~~
✅ Adding .gitkeep files - By default Github won't consider empty folders so we added this dummy file in sub folders of in each day.
~~~
Option 1:
        if not tempFile.exists():
           tempFile.touch()

Option 2:
     tempFile.touch(exist_ok=True)
~~~
✅ Printing clear output for confirmation - Understand how to print and concatinate or interpolation of data
~~~
print(f"Sub Folder Name: {sub} and this folder created in this location: '{day_folder}'")
Where day_folder and sub are variables
~~~
