# Remove All VPN Auto Connect Tasks
# This script removes all VPN auto-connect tasks from Task Scheduler

Write-Host "=== Remove VPN Auto Connect Tasks ===" -ForegroundColor Cyan
Write-Host ""

# Find all AutoConnectVPN tasks
$tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "AutoConnectVPN_*" }

if ($tasks.Count -eq 0) {
    Write-Host "No VPN auto-connect tasks found." -ForegroundColor Yellow
} else {
    Write-Host "Found $($tasks.Count) VPN auto-connect task(s):" -ForegroundColor Yellow
    foreach ($task in $tasks) {
        Write-Host "  - $($task.TaskName)" -ForegroundColor White
    }
    
    Write-Host ""
    $confirm = Read-Host "Remove all these tasks? (Y/N)"
    
    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        foreach ($task in $tasks) {
            try {
                Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
                Write-Host "Removed: $($task.TaskName)" -ForegroundColor Green
            } catch {
                Write-Host "Failed to remove: $($task.TaskName) - $_" -ForegroundColor Red
            }
        }
        Write-Host ""
        Write-Host "All tasks removed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
