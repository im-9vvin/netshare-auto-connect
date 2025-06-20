# NetShare VPN Auto Connect Task Scheduler Setup Script
# Run this script with administrator privileges
# Usage: .\Install-TaskScheduler.ps1 -WifiSSID "YourWiFiName" [-VpnName "YourVPNName"]

param(
    [Parameter(Mandatory=$true)]
    [string]$WifiSSID,
    
    [Parameter(Mandatory=$false)]
    [string]$VpnName = "NetShare"
)

$scriptPath = "$PSScriptRoot\NetShare-AutoConnect.ps1"
$taskName = "AutoConnectVPN_$VpnName"

Write-Host "=== VPN Auto Connect Task Scheduler Setup ===" -ForegroundColor Cyan
Write-Host "WiFi SSID: $WifiSSID" -ForegroundColor Yellow
Write-Host "VPN Name: $VpnName" -ForegroundColor Yellow
Write-Host ""

# Remove existing task if exists
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "Existing scheduled task removed" -ForegroundColor Yellow
} catch {
    # Continue even if task doesn't exist
}

# Create task action with parameters
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`" -WifiSSID `"$WifiSSID`" -VpnName `"$VpnName`""

# Create triggers (at system startup + user logon)
$triggerAtStartup = New-ScheduledTaskTrigger -AtStartup
$triggerAtLogon = New-ScheduledTaskTrigger -AtLogOn

# Task settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartInterval (New-TimeSpan -Minutes 5) `
    -RestartCount 3 `
    -ExecutionTimeLimit (New-TimeSpan -Hours 0)

# Security principal settings (run as current user)
$principal = New-ScheduledTaskPrincipal `
    -UserId $env:USERNAME `
    -LogonType Interactive `
    -RunLevel Highest

# Register the task
try {
    $task = Register-ScheduledTask `
        -TaskName $taskName `
        -Action $action `
        -Trigger $triggerAtStartup, $triggerAtLogon `
        -Settings $settings `
        -Principal $principal `
        -Description "Automatically connects $VpnName VPN when connected to WiFi: $WifiSSID"
    
    Write-Host "SUCCESS: Task Scheduler job registered successfully!" -ForegroundColor Green
    Write-Host "Task Name: $taskName" -ForegroundColor Cyan
    
    # Display task information
    Get-ScheduledTask -TaskName $taskName | Select-Object TaskName, State, Description | Format-List
    
    # Ask if user wants to run now
    $runNow = Read-Host "`nRun the task now? (Y/N)"
    if ($runNow -eq 'Y' -or $runNow -eq 'y') {
        Start-ScheduledTask -TaskName $taskName
        Write-Host "SUCCESS: Task started!" -ForegroundColor Green
    }
    
} catch {
    Write-Host "ERROR: Task Scheduler registration failed: $_" -ForegroundColor Red
    Write-Host "Please make sure you are running with administrator privileges." -ForegroundColor Yellow
}
