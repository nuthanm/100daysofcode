## Learning Concepts :

### Variable Declaration
~~~
Syntax: For normal variable declaration
$variableName = Value

Example:
$rollNumber = 1000

Syntax: For Array of values variable declaration
$variableName = @(value1, value2,...., valueN)

Example:
$ages = @(16,25,28,30)
~~~

### How to create functions (Local functions)
~~~
Syntax:
Function <FunctionName>([$variableName1, $variableName2, ...., $variableNameN])
{

}

Example:
Function Directory-Create-If-Not-Exists($mainFolderpath)
{
}

Calling:
Directory-Create-If-Not-Exists <variable>
~~~

### How to write Print statements
~~~

Syntax:
Write-Host "<Replace_Your_String">

Example:
Write-Host "Begin Process"

Example for concatenate with variables:
Write-Host "Current Index value: {$i}"
~~~

### How to write Looping and Conditional Statements

~~~
Syntax: For Conditions
if (<Condition>)
{

}

Exmaple: Only if file exists
if(Test-Path $pathofthefile)
{
}

Syntax: For not conditions
if (-Not (<condition>))
{
}

Example: Path exists or not
if(-Not(Test-Path $pathofthefile))
{
}

Syntax: For Loops
Syntax:
ForEach($eachItem in $Object)
{
}

Example:
ForEach($subDir in $SubDirectories)
{
  Write-Host "Current Sub DirectoryName: $subDir"
}
~~~

## How to create a directory and other important concepts related to directory

### For Directory Creation:
~~~
syntax:
  New-Item -Path <variable_FolderPath> -ItemType Directory

Example:
   New-Item -Path $mainFolderpath -ItemType Directory
~~~

### For combining multiple Paths
~~~
Syntax:
$VariableToHoldCombinedPath = Join-Path -Path <variableFilePath> -ChildPath "<Add_Your_Folder>"

Example:
$dayWiseFolder = Join-Path -Path $FoldersCreateLocation -ChildPath "Day $i"
~~~

### Empty File Creation
~~~
Syntax:
Set-Content -Path <Variable> -Value ""  # Creates an empty file

Example:
Set-Content -Path $dummyFilePath -Value ""  # Creates an empty file

~~~
