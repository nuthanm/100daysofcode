# Create-Dynamic-Folders
# Variables Declaration
$varloopEnd = 6 # You can change this number depends on your need
$varloopBegin = 1
$varcsharp = "C-Sharp"
$varpython = "Python"
$varpowershell = "Powershell"
$FoldersCreateLocation = "<Your_Path>" # Example: D:\Users\nmurarysetty\temp\
$subFolders = @($varcsharp, $varpython, $varpowershell)

# Function to check directory-exists or not and create if not
Function Directory-Create-If-Not-Exists($mainFolderpath)
{
    Write-Host "Begin main folder creation"
        if(-Not (Test-Path $mainFolderpath))
        {
            Write-Host "Path not exists, so creating a directory"
            
            # New-Item : Create a directory if that folder doesn't exist and ItemType tells whether it's a directory or File
            New-Item -Path $mainFolderpath -ItemType Directory
            
            Write-Host "Created Main Directory : $mainFolderpath"
            
            ForEach($subDir in $subFolders)
            {
                $subFoldersDirectory = Join-Path -Path $mainFolderpath -ChildPath $subDir            
                SubDirectory-CreateWithDummyFile-If-Not-Exists $subFoldersDirectory
            }
        }
    
    Write-Host "End main folder creation"
}
 
# For sub directories and dummy file
Function SubDirectory-CreateWithDummyFile-If-Not-Exists($subPath)
{
    If (-Not (Test-Path $subPath)) {
        New-Item -Path $subPath -ItemType Directory | Out-Null
        Write-Host "Created Sub Directory : $subPath"
    }
    
    # Add a dummy file inside the subfolder
    $dummyFilePath = Join-Path -Path $subPath -ChildPath ".gitkeep"
    If (-Not (Test-Path $dummyFilePath)) {
        Set-Content -Path $dummyFilePath -Value ""  # Creates an empty file
        Write-Host "Created Dummy File: $dummyFilePath"
    }
}
 
# Loop till 100
ForEach ($i in $varloopBegin..$varloopEnd)
{
    Write-Host "Day $i"
    # Join-Path helps us to concate the path
    $dayWiseFolder = Join-Path -Path $FoldersCreateLocation -ChildPath "Day $i"
    Write-Host $dayWiseFolder
    # Test-Path => Helps to check if folder exists or not 
    Directory-Create-If-Not-Exists $dayWiseFolder 
}
