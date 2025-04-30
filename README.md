# Automate Our Daily Work
In this repository, we take every day use case and convert that into a project. We write code in c-sharp, python and powershell (If applicable).

## Programming and Scripting Languages
- C-Sharp
- Python
- Powershell
- Azure CLI

## Folder Structure 
- /Learning
- /git-hooks
   - /pre-commit
   - /pre-push
   - ....
   - ....
- /Automation
   
 
## Use Cases
1. Create 100 folders in Day 1, Day 2,...., Day 100 format and in each folder C-Sharp, Python and Powershell folders:
   - [Dynamic Folders Creation - Code - Chsarp](https://github.com/nuthanm/automate_our_daily_work/blob/main/1_Create_Dynamic_Folders/C-Sharp/Create-Dynamic-Folders.cs)
   - [Dynamic Folders Creation - Code - Powershell](https://github.com/nuthanm/automate_our_daily_work/blob/main/1_Create_Dynamic_Folders/Powershell/create-dynamic-folders.ps1)
   - [Dynamic Folders Creation - Code - Python](https://github.com/nuthanm/automate_our_daily_work/blob/main/1_Create_Dynamic_Folders/Python/create-dynamic-folders.py)
   - **Acheivement:** If you automate this process, you can save a lot of manual time.
2. Team member wise, number of PR's and their review comments
   - [Extract PR Details and its count - Code - Powershell](https://github.com/nuthanm/automate_our_daily_work/blob/main/Automation/Get-PR-Count-From-Each-Team-Member.ps1)
   - [Extract_PR_AND_Reviewer_Comments_Count_Details_Code_Powershell](https://github.com/nuthanm/automate_our_daily_work/blob/main/Automation/Get-PR-and-Reviewers-Count-From-Each-Team-Member.ps1)
   - **Acheivement:** This automation helps in identify how many PR's and review comments for each PR from each Team member. All these stats helps to understand how developers are doing.
3. Update work item (Example: Task) to update hours automatate.
   - [Update-Work-Items-Using-Powershell](https://github.com/nuthanm/automate_our_daily_work/blob/main/Automation/Update-Work-Item-details-using-powershell.ps1)
   - **Acheivement:** Avoid manual updating hours and even we can update the comment in this current logic but still enhancing this powershell script.
