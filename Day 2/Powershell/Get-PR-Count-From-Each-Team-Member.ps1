# Define your Azure DevOps organization and project (update these values)
$organization = "https://dev.azure.com/<Replace_Your_Organization>"
$project = "<Replace_Your_Project>"

# Define your team members (team's 20 members)
$teamMembers = @(
    "test@domain.com"
    # Add all 20 team members here
)

# Define specific repositories to check (modify this list)
$specificRepositories = @(
    "abc-job",
    "abc-api"
    # Add more repositories as needed
)

$sprintName = "Sprint3"
$startDate = "2025-03-26"
#$endDate = Get-Date -Format "yyyy-MM-dd"
$endDate = "2025-04-16"

Write-Host "Running PR analysis for team - $sprintName from $startDate to $endDate"

# Initialize results collection
$results = @()

# Get today's date for logging
$currentDate = Get-Date -Format "yyyy-MM-dd"
Write-Host "Running PR analysis for team on $currentDate"

foreach ($member in $teamMembers) {
    Write-Host "Processing PRs for $member..."
    
    # Get PRs created by this team member - only active and completed status
    # Using correct syntax with separate status flags
    $prs = az repos pr list --creator $member --status completed --organization $organization --project $project --output json | ConvertFrom-Json
    
    # Get PRs created by this team member within the specific date range, # and only active and completed status 
    $prs = az repos pr list --creator $member --status active --status completed --organization $organization --project $project --output json | ConvertFrom-Json | Where-Object {$_.creationDate -ge $startDate -and $_.creationDate -le $endDate}

    # Process the PRs for this member if any exist
    if ($prs -and $prs.Count -gt 0) {
        foreach ($pr in $prs) {
            # Check if this PR is in one of our specified repositories
            $repoName = $pr.repository.name
            if ($specificRepositories -contains $repoName) {
                Write-Host "  - Analyzing PR #$($pr.pullRequestId): $($pr.title) in repository $repoName"
                
                # Get repository ID for this PR
                $repoId = $pr.repository.id
                
                
                # Add to results
                $results += [PSCustomObject]@{
                    TeamMember = $member
                    PullRequestId = $pr.pullRequestId
                    Title = $pr.title
                    CreationDate = $pr.creationDate
                    Status = $pr.status
                    Repository = $repoName
                    # ReviewerCommentCount = $reviewerComments
                    # CommentorDetails = $commentorDetails
                }
            }
        }
    } else {
        Write-Host "  No active or completed PRs found for $member"
    }
}

# Calculate summary statistics
$memberStats = $results | Group-Object TeamMember | ForEach-Object {
    $prCount = $_.Count
    # $totalComments = ($_.Group | Measure-Object ReviewerCommentCount -Sum).Sum
    # $avgCommentsPerPR = if ($prCount -gt 0) { [math]::Round($totalComments / $prCount, 1) } else { 0 }
    
    [PSCustomObject]@{
        TeamMember = $_.Name
        TotalPRs = $prCount
        # TotalReviewerComments = $totalComments
        # AvgCommentsPerPR = $avgCommentsPerPR
    }
}

# Export detailed results to CSV
$outputPath = "DragonTeam_PRStats_${sprintName}_${startDate}_to_${endDate}.csv"
$results | Export-Csv -Path $outputPath -NoTypeInformation
Write-Host "Detailed PR data exported to $outputPath"

# Export summary to CSV
$summaryPath = "DragonTeam_PRSummary_${sprintName}_${startDate}_to_${endDate}.csv"
$memberStats | Export-Csv -Path $summaryPath -NoTypeInformation
Write-Host "Team summary exported to $summaryPath"

# Display summary in console
Write-Host "`nSummary of PR activity for Team:"
$memberStats | Format-Table -AutoSize

# Display team totals
$teamTotalPRs = ($memberStats | Measure-Object TotalPRs -Sum).Sum
# $teamTotalComments = ($memberStats | Measure-Object TotalReviewerComments -Sum).Sum
# $teamAvgCommentsPerPR = if ($teamTotalPRs -gt 0) { [math]::Round($teamTotalComments / $teamTotalPRs, 1) } else { 0 }

Write-Host "`nTeam Totals:"
Write-Host "Total PRs: $teamTotalPRs"
# Write-Host "Total Reviewer Comments: $teamTotalComments"
# Write-Host "Team Average Comments Per PR: $teamAvgCommentsPerPR"
