# Get your branch along with name, email and many more
$logFile = "<Replace_Your_Path>\orphan_branches_PAT.log"
Write-Output "-----------------------------------------------------"| Out-File -Append -FilePath $logFile
$startTime = $(Get-Date)
Write-Output "Task Begin at $($startTime)" | Out-File -Append -FilePath $logFile
Write-Host "Task Begin at $($startTime)"


$org = "https://dev.azure.com/<Replace_Your_Organization>"
$project = "<Replace_Your_Project>"
$pat = "<Replace_Your_PAT_TOKEN>"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
$success = $true
$outputCsv = "<Feel_free_to_change_your_file_name>.csv"

Write-Output "Configure the orgranization: $($org)" | Out-File -Append -FilePath $logFile

# Login and set defaults (if not already done)
try {
    az devops configure --defaults organization=$org project=$project
} catch {
    Write-Error "❌ Failed to set Azure DevOps defaults. Ensure you are logged in and project/org values are correct."
    exit 1
}

# Get all repositories
# The following command filters from your project and as well repo which is not disabled
# az repos list --project '<Your_ProjectName>'  --output json | ConvertFrom-Json | Where-Object { -not $_.isDisabled -and $_.name -eq "<Your_Repo_Name>" }

try {
    # Get repos specific to project
    $repos = az repos list --project $project --output json | ConvertFrom-Json

    # $repos = az repos list --output json | ConvertFrom-Json

    $enabledRepos = $repos | Where-Object { -not $_.isDisabled }
    $disabledRepos = $repos | Where-Object { $_.isDisabled }
} catch {
    Write-Error "❌ Failed to fetch repositories. Check project name or your access."
    exit 1
}


# Object for storing branches information
$branchData = @()

# Disabled Repos
foreach ($repo in $disabledRepos) 
{
       $branchData += [PSCustomObject]@{
            Repository   = $repo.name
            Branch       = "-"
            #NumberOfBranches = "-"
            Author       = "-"
            Email        = "-"
            #NumberOfCommits = "-"
            LastCommitOn = "-"
            Status       = "Disabled"
        }
}

# Enabled Repos
$total = $enabledRepos.Count
$repoIndex = 1

foreach ($repo in $enabledRepos) {    
    $repoName = $repo.name    
    Write-Host "`rProcessing repository $repoIndex of $total..." -NoNewline
    
    <# For testing
    if($repoIndex -eq 2) {
    break
    }
    #>
        
    Write-Output "-----------------------------------------------------"| Out-File -Append -FilePath $logFile
    Write-Output "Begin - Repository Details : $repoName" | Out-File -Append -FilePath $logFile
    
     # Get all branches
    try {
        $branches = az repos ref list --repository $repoName --filter heads/ --output json | ConvertFrom-Json
    } catch {
        Write-Warning "⚠️ Failed to fetch branches for repository: $repoName"
        $success = $false
        continue
    }
    
    foreach ($branch in $branches) {
        $branchName = $branch.name -replace "refs/heads/", ""
        $objectId = $branch.objectId
        
        Write-Output "Begin - Branch Details : $branchName" | Out-File -Append -FilePath $logFile
        
        try {

            $embedProject = $project -replace ' ', '%20'
            $commitUrl = "$org/$embedProject/_apis/git/repositories/$($repo.id)/commits/$($objectId)?api-version=7.1-preview.1"

            # Write-Output "$commitUrl" | Out-File -Append -FilePath $logFile
            $commits = Invoke-RestMethod -Uri $($commitUrl) -Method Get -Headers @{ Authorization = "Basic $($base64AuthInfo)" }
            
            # Write-Output ($commits | ConvertTo-Json -Depth 5) | Out-File -Append -FilePath $logFile

            # $commits is your array of commit objects (from API)
            $latestCommit = $commits | Sort-Object { [datetime]$_.committer.date } -Descending | Select-Object -First 1

	    if ($latestCommit -and $latestCommit.author) {
                $commitDate = [DateTime]::Parse($latestCommit.author.date)
                $daysOld = (Get-Date) - $commitDate
                $readyForDelete = if ($daysOld.Days -gt 60) { "Ready for delete" } else { "Active" }

                $branchData += [PSCustomObject]@{
                    Repository     = $repoName
                    Branch         = $branchName
                    #NumberOfBranches = $branches.count
                    Author         = $latestCommit.author.name
                    Email          = $latestCommit.author.email
                    #NumberOfCommits = $latestCommit.count
                    LastCommitOn   = $latestCommit.author.date
                    Status = $readyForDelete
                }
             } else {
                $branchData += [PSCustomObject]@{
                     Repository     = $repoName
                     Branch         = $branchName
                     #NumberOfBranches = $branches.count
                     Author         = "NotFound"
                     Email          = "NotFound"
                     #NumberOfCommits = "NotFound"
                     LastCommitOn   = "NotFound"
                     Status = "Unknown"
                }
            }

        }
        catch {
            $branchData += [PSCustomObject]@{
                Repository     = $repoName
                Branch         = $branchName
                #NumberOfBranches = $branches.count
                Author         = "Error"
                Email          = "Error"
                #NumberOfCommits = "Error"
                LastCommitOn   = "Error"
                Status = "Error"
            }

            #Write-Host "Commit URL: $commitUrl"
            #Write-Host "Error fetching commit for $repoName/$branchName : $($_.Exception.Message)"
            #Write-Host "Full error details: $_"

        }

        #Write-Output "End - Branch Details : $branchName" | Out-File -Append -FilePath $logFile
     }
     $repoIndex++

     #Write-Output "End - Repository Details : $repoName" | Out-File -Append -FilePath $logFile
}

# Export to CSV

if ($branchData.Count -gt 0) {
    $branchData | Export-Csv -Path $outputCsv -NoTypeInformation
    if ($success) {
        Write-Host "✅ Successfully exported orphan branches to $outputCsv"
    } else {
        Write-Warning "⚠️ Some repositories or branches were skipped due to errors. Partial data saved to $outputCsv"
    }
} else {
    Write-Host "❌ No data was exported. Script failed to retrieve any branch info."
}
$endTime = $(Get-Date)
Write-Host "Task End at $($endTime)" | Out-File -Append -FilePath $logFile

$durationTimeTaken = $endTime - $startTime
Write-Host "⏱️ Script completed in: $($durationTimeTaken.ToString())"
