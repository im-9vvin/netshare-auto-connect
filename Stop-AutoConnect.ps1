# Stop VPN Auto Connect Tasks
# This script stops running VPN auto-connect tasks without removing them
# Usage: .\Stop-AutoConnect.ps1 [-VpnName "YourVPNName"]

param(
    [Parameter(Mandatory=$false)]
    [string]$VpnName
)

Write-Host "=== Stop VPN Auto Connect Tasks ===" -ForegroundColor Cyan
Write-Host ""

# Find AutoConnectVPN tasks
if ($VpnName) {
    $taskPattern = "AutoConnectVPN_$VpnName"
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskPattern }
} else {
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "AutoConnectVPN_*" }
}

if ($tasks.Count -eq 0) {
    if ($VpnName) {
        Write-Host "No VPN auto-connect task found for: $VpnName" -ForegroundColor Yellow
    } else {
        Write-Host "No VPN auto-connect tasks found." -ForegroundColor Yellow
    }
} else {
    Write-Host "Found $($tasks.Count) VPN auto-connect task(s):" -ForegroundColor Yellow
    
    foreach ($task in $tasks) {
        Write-Host ""
        Write-Host "Task: $($task.TaskName)" -ForegroundColor White
        Write-Host "  Current State: $($task.State)" -ForegroundColor $(if ($task.State -eq "Ready") { "Green" } elseif ($task.State -eq "Running") { "Yellow" } else { "Gray" })
        
        # Stop the task if it's running
        if ($task.State -eq "Running") {
            try {
                Stop-ScheduledTask -TaskName $task.TaskName
                Write-Host "  [STOPPED] Task has been stopped" -ForegroundColor Green
            } catch {
                Write-Host "  [ERROR] Failed to stop task: $_" -ForegroundColor Red
            }
        }
        
        # Disable the task
        try {
            Disable-ScheduledTask -TaskName $task.TaskName | Out-Null
            Write-Host "  [DISABLED] Task has been disabled" -ForegroundColor Green
            Write-Host "  The task will not run until re-enabled" -ForegroundColor Yellow
        } catch {
            Write-Host "  [ERROR] Failed to disable task: $_" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "To re-enable the tasks, use Enable-AutoConnect.bat" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
