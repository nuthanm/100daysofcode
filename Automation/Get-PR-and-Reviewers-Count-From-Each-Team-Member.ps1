# Capture the start time
$startTime = Get-Date

# Define your Azure DevOps organization and project (update these values)
$organization = "https://dev.azure.com/<Replace_Your_Organization>"
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
Write-Host "Running PR analysis for team - $sprintName from $startDate to $endDate"


# Initialize results collection
$results = @()
$index = 1

# Get today's date for logging
$currentDate = Get-Date -Format "yyyy-MM-dd"
Write-Host "Running PR analysis for team on $currentDate"

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

        foreach ($pr in $prs) 
        {
            
            Write-Host "  $($index) - Analyzing PR #$($pr.pullRequestId): $($pr.title) and date of closed : $($pr.closedDate) in repository $($pr.repository.name)"

            # Get threads (comments) for this PR using REST API approach
            $threadsResult = az devops invoke --area git --resource pullRequestThreads --org "$organization" --route-parameters project="$project" repositoryId="$($pr.repository.id)" pullRequestId="$($pr.pullRequestId)" --api-version 7.0 --output json | ConvertFrom-Json
                                            
            # Count comments from reviewers (excluding the PR creator)
            $reviewerComments = 0
            $commentors = @{}
        
            # Check if there are no threads or comments
            if (-not $threadsResult -or -not $threadsResult.value) {
                Write-Host "No thread or comments available for this PR: $($pr.pullRequestId)"
                $index++
                continue
            }

            # Write-Host "Results exist in $threadsResult.value"
            foreach ($thread in $threadsResult.value) 
            {
               foreach ($comment in $thread.comments) 
               {
                  if ($comment.commentType -eq "text" -and $comment.content -ne $null) 
                  {
                      $reviewerComments++
            
                      # Track individual commentors
                      $commentorName = $comment.author.uniqueName
        
                      if ($commentors.ContainsKey($commentorName)) 
                      {
                          $commentors[$commentorName]++
                      } 
                      else 
                      {
                          $commentors[$commentorName] = 1
                      }                                          
                  }
        
                  # Format the commentor details
                  $commentorDetails = ($commentors.GetEnumerator() | ForEach-Object { "$($_.Key): $($_.Value)" }) -join "; "
               }
            }

            $results += [PSCustomObject]@{
                TeamMember = $member
                PullRequestId = $pr.pullRequestId
                Title = $pr.title
                CreationDate = $pr.creationDate
                ClosedDate = $pr.closedDate
                Status = $pr.status
                Repository = $pr.repository.name
                ReviewerCommentCount = $reviewerComments
                CommentorDetails = $commentorDetails
            }
            
            $index++
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
    $totalComments = ($_.Group | Measure-Object ReviewerCommentCount -Sum).Sum
    $avgCommentsPerPR = if ($prCount -gt 0) { [math]::Round($totalComments / $prCount, 1) } else { 0 }
    
    [PSCustomObject]@{
        TeamMember = $_.Name
        TotalPRs = $prCount
        TotalReviewerComments = $totalComments
        AvgCommentsPerPR = $avgCommentsPerPR
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
$teamTotalComments = ($memberStats | Measure-Object TotalReviewerComments -Sum).Sum
$teamAvgCommentsPerPR = if ($teamTotalPRs -gt 0) { [math]::Round($teamTotalComments / $teamTotalPRs, 1) } else { 0 }

# Capture End Date
$endTime = Get-Date

# Calculate how long this process took to complete
$duration = $endTime - $startTime

Write-Host "`nTeam Totals:"
Write-Host "Total PRs: $teamTotalPRs"
Write-Host "Total Reviewer Comments: $teamTotalComments"
Write-Host "Team Average Comments Per PR: $teamAvgCommentsPerPR"
Write-Host "Script execution time for reading and generate into excel file : $($duration.Hours) hours, $($duration.Minutes) minutes, $($duration.Seconds) seconds"
