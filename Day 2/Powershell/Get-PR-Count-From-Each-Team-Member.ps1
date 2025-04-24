# Define your Azure DevOps organization and project (update these values)
$organization = "https://dev.azure.com/<Replace_Your_OrganizationName>"
$project = "<Replace_Your_Project>"

# Define your team members
$teamMembers = @(   
    "nani@hello.com"    
    # Add all 20 team members here
)

# Define specific repositories to check (modify this list)
$specificRepositories = @(    
    "nani-demos-api"    
    # Add more repositories as needed
)

$sprintName = "Sprint1"
$startDate = "2021-01-01"
$endDate = Get-Date -Format "yyyy-MM-dd"
#$endDate = "2025-04-16"
Write-Host "Running PR analysis for the team - $sprintName from $startDate to $endDate"

# Initialize results collection
$results = @()

# Get today's date for logging
$currentDate = Get-Date -Format "yyyy-MM-dd"
Write-Host "Running PR analysis for the team on $currentDate"

function Get-AllPRs {
    param (
        [string]$organization,
        [string]$project,
        [string]$repoName,
        [string]$member,
        [string]$startDate,
        [string]$endDate,
        [int]$pageSize = 100
    )

    $prs = @()
    $skip = 0

    do {
        $result = az repos pr list --creator $member --status completed --organization $organization --project $project --repository $repoName --top 	$pageSize --skip $skip --output json | ConvertFrom-Json
        $prs += $result
        $skip += $pageSize
    } while ($result.Count -eq $pageSize)

    return $prs | Where-Object {$_.closedDate -ge $startDate -and $_.closedDate -le $endDate} | Sort-Object -Property closedDate -Descending
}

# Update the PR fetching logic to use the new function
foreach ($member in $teamMembers) 
{
    Write-Host "Processing PRs for $member..."

    foreach ($repoName in $specificRepositories) 
    {
                
        $prs = Get-AllPRs -organization $organization -project $project -repoName $repoName -member $member -startDate $startDate -endDate $endDate

        Write-Host "Total Number of PRs for each member: $($member) and $($prs.Count)"

        if ($prs.Count -eq 0) {
            Write-Host "There are no completed PRs found for $member during this period: $($startDate) and $($endDate)"
            continue
        }

        foreach ($pr in $prs) {
            Write-Host "  - Analyzing PR #$($pr.pullRequestId): $($pr.title) and date of closed : $($pr.closedDate) in repository $($pr.repository.name)"

            $results += [PSCustomObject]@{
                TeamMember = $member
                PullRequestId = $pr.pullRequestId
                Title = $pr.title
                CreationDate = $pr.creationDate
                ClosedDate = $pr.closedDate
                Status = $pr.status
                Repository = $pr.repository.name
            }
        }
    }
}

if ($results.Count -eq 0) 
{
    Write-Host " There are no PR details to add in excel found for $member during this period: $($startDate) and $($endDate)"
    continue    
}

# Calculate summary statistics
$memberStats = $results | Group-Object TeamMember | ForEach-Object {
    $prCount = $_.Count
    
    [PSCustomObject]@{
        TeamMember = $_.Name
        TotalPRs = $prCount
    }
}

# Export detailed results to CSV
$outputPath = "Team_PRStats_${sprintName}_${startDate}_to_${endDate}.csv"
$results | Export-Csv -Path $outputPath -NoTypeInformation
Write-Host "Detailed PR data exported to $outputPath"

# Export summary to CSV
$summaryPath = "Team_PRSummary_${sprintName}_${startDate}_to_${endDate}.csv"
$memberStats | Export-Csv -Path $summaryPath -NoTypeInformation
Write-Host "Team summary exported to $summaryPath"

# Display summary in console
Write-Host "`nSummary of PR activity for Team:"
$memberStats | Format-Table -AutoSize

# Display team totals
$teamTotalPRs = ($memberStats | Measure-Object TotalPRs -Sum).Sum

Write-Host "`nTeam Totals:"
Write-Host "Total PRs: $teamTotalPRs"
