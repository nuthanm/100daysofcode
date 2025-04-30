# Set Variables
$WORK_ITEM_ID = 5630331   # Replace with your actual Task ID
$COMPLETED_WORK_FIELD = "Custom.Completed"
$REMAINING_WORK_FIELD = "Microsoft.VSTS.Scheduling.RemainingWork"

# Get current day of the week (0 = Sunday, 6 = Saturday)
$dayOfWeek = (Get-Date).DayOfWeek

# If it's Saturday (6) or Sunday (0), then exit
if ($dayOfWeek -eq 0 -or $dayOfWeek -eq 6) {
    Write-Host "Today is weekend. No update performed."
    exit
}

# Get current date (YYYY-MM-DD)
$currentDate = Get-Date -Format "yyyy-MM-dd"

# Prepare the comment
$comment = @"
As on $currentDate worked on,
1. PR review, design approach discussion
2. Deployments and dev unit test validation along with team
3. Pair programming and clarify doubts
4. Fixed deployment failure issue and clarify the doubts on newer approaches with solution architect.
"@

# Retrieve current work item fields
try {
    $workItemDetails = az boards work-item show --id $WORK_ITEM_ID --query "fields" --output json | ConvertFrom-Json
	Write-Host $workItemDetails

    if ($workItemDetails) { # -and $workItemDetails.fields) {
        $completedWork = $workItemDetails."$COMPLETED_WORK_FIELD"
        $remainingWork = $workItemDetails."$REMAINING_WORK_FIELD"

        Write-Host "Completed Work (Retrieved): $completedWork"
        Write-Host "Remaining Work (Retrieved): $remainingWork"

        # Set default values if not found (handle cases where the fields might not be set initially)
        if (-not $completedWork -or ([string]::IsNullOrEmpty($completedWork))) { $completedWork = 0 }
        if (-not $remainingWork -or ([string]::IsNullOrEmpty($remainingWork))) { $remainingWork = 0 }

        # Ensure they are treated as numbers for comparison
        $completedWork = [int]$completedWork
        $remainingWork = [int]$remainingWork

        # Update Completed Work +6, Remaining Work -6 (or remaining to 0)
        if ($remainingWork -gt 0) {
            if ($remainingWork -ge 6) {
                $newCompletedWork = $completedWork + 6
                $newRemainingWork = $remainingWork - 6
            } else {
                $newCompletedWork = $completedWork + $remainingWork
                $newRemainingWork = 0
            }

            Write-Host "Updating Work Item $($WORK_ITEM_ID): CompletedWork=$newCompletedWork RemainingWork=$newRemainingWork"

            try {
                # Update the Work Item with new values
                az boards work-item update --id $WORK_ITEM_ID --fields "$COMPLETED_WORK_FIELD=$newCompletedWork" "$REMAINING_WORK_FIELD=$newRemainingWork"

                # Post comment to discussion in the Azure DevOps task
                az boards work-item update --id $WORK_ITEM_ID --discussion "$comment"

                Write-Host "Updated Work Item $($WORK_ITEM_ID) along with comment and CompletedWork=$newCompletedWork RemainingWork=$newRemainingWork"
            } catch {
                Write-Host "Error updating work item: $_"
            }
        } else {
            Write-Host "Work Item $WORK_ITEM_ID already completed or no remaining work."
        }
    } else {
        Write-Host "Error: Could not retrieve work item details or fields are missing."
    }
} catch {
    Write-Host "Error retrieving work item details: $_"
    Write-Host "Ensure the Work Item ID is correct and you have the necessary permissions."
    Write-Host "Also, verify that the Azure DevOps CLI ('az') is configured correctly."
}