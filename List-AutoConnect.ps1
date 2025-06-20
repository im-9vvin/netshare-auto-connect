# List VPN Auto Connect Tasks
# This script lists all VPN auto-connect tasks and their status

Write-Host "=== VPN Auto Connect Tasks List ===" -ForegroundColor Cyan
Write-Host ""

# Find all AutoConnectVPN tasks
$tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "AutoConnectVPN_*" }

if ($tasks.Count -eq 0) {
    Write-Host "No VPN auto-connect tasks found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To create a new auto-connect task, use:" -ForegroundColor Cyan
    Write-Host '  Install-AutoStart.bat "WiFi_SSID" [VPN_Name]' -ForegroundColor White
} else {
    Write-Host "Found $($tasks.Count) VPN auto-connect task(s):" -ForegroundColor Green
    Write-Host ""
    
    # Create a summary table
    $taskInfo = @()
    
    foreach ($task in $tasks) {
        # Extract VPN name from task name
        $vpnName = $task.TaskName -replace "AutoConnectVPN_", ""
        
        # Get task info
        $taskDetails = Get-ScheduledTaskInfo -TaskName $task.TaskName -ErrorAction SilentlyContinue
        
        # Create custom object
        $info = [PSCustomObject]@{
            "VPN Name" = $vpnName
            "Task State" = $task.State
            "Last Run Time" = if ($taskDetails.LastRunTime -eq [DateTime]::MinValue) { "Never" } else { $taskDetails.LastRunTime.ToString("yyyy-MM-dd HH:mm:ss") }
            "Next Run Time" = if ($task.State -eq "Disabled") { "Disabled" } elseif ($taskDetails.NextRunTime -eq [DateTime]::MinValue) { "Not scheduled" } else { $taskDetails.NextRunTime.ToString("yyyy-MM-dd HH:mm:ss") }
            "Last Result" = if ($taskDetails.LastTaskResult -eq 0) { "Success" } elseif ($taskDetails.LastTaskResult -eq 267011) { "Running" } else { "Error ($($taskDetails.LastTaskResult))" }
        }
        
        $taskInfo += $info
    }
    
    # Display as table
    $taskInfo | Format-Table -AutoSize
    
    Write-Host ""
    Write-Host "Task Management Commands:" -ForegroundColor Cyan
    Write-Host "  Stop all tasks:        Stop-AutoConnect.bat" -ForegroundColor White
    Write-Host "  Stop specific task:    Stop-AutoConnect.bat ""VPN_Name""" -ForegroundColor White
    Write-Host "  Enable all tasks:      Enable-AutoConnect.bat" -ForegroundColor White
    Write-Host "  Enable specific task:  Enable-AutoConnect.bat ""VPN_Name""" -ForegroundColor White
    Write-Host "  Remove all tasks:      Remove-AllAutoConnect.bat" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
