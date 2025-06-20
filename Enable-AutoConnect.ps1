# Enable VPN Auto Connect Tasks
# This script re-enables VPN auto-connect tasks that were previously disabled
# Usage: .\Enable-AutoConnect.ps1 [-VpnName "YourVPNName"]

param(
    [Parameter(Mandatory=$false)]
    [string]$VpnName
)

Write-Host "=== Enable VPN Auto Connect Tasks ===" -ForegroundColor Cyan
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
        Write-Host "  Current State: $($task.State)" -ForegroundColor $(if ($task.State -eq "Ready") { "Green" } elseif ($task.State -eq "Disabled") { "Red" } else { "Yellow" })
        
        # Enable the task if it's disabled
        if ($task.State -eq "Disabled") {
            try {
                Enable-ScheduledTask -TaskName $task.TaskName | Out-Null
                Write-Host "  [ENABLED] Task has been enabled" -ForegroundColor Green
                
                # Ask if user wants to start the task now
                $startNow = Read-Host "  Start the task now? (Y/N)"
                if ($startNow -eq 'Y' -or $startNow -eq 'y') {
                    Start-ScheduledTask -TaskName $task.TaskName
                    Write-Host "  [STARTED] Task is now running" -ForegroundColor Green
                }
            } catch {
                Write-Host "  [ERROR] Failed to enable task: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "  Task is already enabled" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
