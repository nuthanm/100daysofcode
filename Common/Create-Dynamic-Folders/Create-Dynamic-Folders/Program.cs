// Use Case: Create number of folders dynamically and in each folder creates C-Sharp, Python and Powershell sub folders. Main Folder name should be in "Day <Number>" format.

using System.Diagnostics;

Stopwatch sw = Stopwatch.StartNew();
// Step 1: Number of Main folders to create
int numberOfFolder = 100;


const string CSharp = "C-Sharp";
const string Python = "Python";
const string PowerShell = "Powershell";

// Step 2: Folders creation path
string whereToCreate = @"D:\Git\100daysofcode\";

// Step 3: Loop till numberOfFolder value and check Directory exist or not. If not then create a folder and once it is done then create a folder of Csharp, Python and Powershell

for (int i = 1; i <= numberOfFolder; i++)
{
    if (!Directory.Exists(Path.Combine($"{whereToCreate}Day {i}")))
    {
        Directory.CreateDirectory(Path.Combine($"{whereToCreate}Day {i}"));
    }

    CreateOrNothingSubFolders(i);
}
sw.Stop();
Console.WriteLine($"Total Time it takes to create the folders: {sw.ElapsedMilliseconds}");

void CreateOrNothingSubFolders(int index)
{
    // Create sub folders inside the main folder
    if (!Directory.Exists(Path.Combine($"{whereToCreate}Day {index}\\{CSharp}")))
    {
        Directory.CreateDirectory(Path.Combine($"{whereToCreate}Day {index}\\{CSharp}"));
    }
    if (!Directory.Exists(Path.Combine($"{whereToCreate}Day {index}\\{Python}")))
    {
        Directory.CreateDirectory(Path.Combine($"{whereToCreate}Day {index}\\{Python}"));
    }
    if (!Directory.Exists(Path.Combine($"{whereToCreate}Day {index}\\{PowerShell}")))
    {
        Directory.CreateDirectory(Path.Combine($"{whereToCreate}Day {index}\\{PowerShell}"));
    }
}