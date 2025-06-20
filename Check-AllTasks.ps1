# Check All VPN Auto Connect Tasks (including legacy)
# This script checks for both old and new format tasks

Write-Host "=== Checking All VPN Auto Connect Tasks ===" -ForegroundColor Cyan
Write-Host ""

# Check for old format task
Write-Host "Checking legacy format tasks..." -ForegroundColor Yellow
$legacyTask = Get-ScheduledTask -TaskName "NetShareVPNAutoConnect" -ErrorAction SilentlyContinue

if ($legacyTask) {
    Write-Host "Found legacy task:" -ForegroundColor Green
    Write-Host "  Name: $($legacyTask.TaskName)"
    Write-Host "  State: $($legacyTask.State)" -ForegroundColor $(if ($legacyTask.State -eq "Ready") { "Green" } elseif ($legacyTask.State -eq "Disabled") { "Red" } else { "Yellow" })
    Write-Host "  Description: $($legacyTask.Description)"
    Write-Host ""
    Write-Host "  This task was created with an older version of the script." -ForegroundColor Yellow
    Write-Host "  To manage this task:" -ForegroundColor Cyan
    Write-Host "    - Remove it: Unregister-ScheduledTask -TaskName 'NetShareVPNAutoConnect' -Confirm:`$false" -ForegroundColor White
    Write-Host "    - Or use Task Scheduler GUI to manage it manually" -ForegroundColor White
} else {
    Write-Host "No legacy tasks found." -ForegroundColor Gray
}

Write-Host ""
Write-Host "Checking new format tasks..." -ForegroundColor Yellow

# Check for new format tasks
$newTasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "AutoConnectVPN_*" }

if ($newTasks) {
    Write-Host "Found $($newTasks.Count) new format task(s):" -ForegroundColor Green
    foreach ($task in $newTasks) {
        Write-Host "  - $($task.TaskName) [State: $($task.State)]"
    }
} else {
    Write-Host "No new format tasks found." -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
$totalTasks = 0
if ($legacyTask) { $totalTasks++ }
if ($newTasks) { $totalTasks += $newTasks.Count }

Write-Host "Total VPN auto-connect tasks found: $totalTasks" -ForegroundColor $(if ($totalTasks -gt 0) { "Green" } else { "Yellow" })

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
