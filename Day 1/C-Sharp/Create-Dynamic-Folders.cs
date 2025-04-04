﻿// Use Case: Create number of folders dynamically and in each folder creates C-Sharp, Python and Powershell sub folders. Main Folder name should be in "Day <Number>" format.
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
    string mainFolderPath = Path.Combine(whereToCreate, $"Day {i}");
    Directory.CreateDirectory(mainFolderPath);

    CreateSubFolders(mainFolderPath);
}

sw.Stop();
Console.WriteLine($"Total Time it takes to create the folders: {sw.ElapsedMilliseconds}ms");

void CreateSubFolders(string mainFolderPath)
{
    string[] subFolders = { CSharp, Python, PowerShell };

    foreach (var subFolder in subFolders)
    {
        string subFolderPath = Path.Combine(mainFolderPath, subFolder);
        Directory.CreateDirectory(subFolderPath);
        using (File.Create(Path.Combine(subFolderPath, ".gitkeep"))) { }
    }
}
