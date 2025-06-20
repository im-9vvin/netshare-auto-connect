# VPN Status Check Script
# Usage: .\Check-Status.ps1 [-WifiSSID "YourWiFiName"] [-VpnName "YourVPNName"]

param(
    [Parameter(Mandatory=$false)]
    [string]$WifiSSID,
    
    [Parameter(Mandatory=$false)]
    [string]$VpnName = "NetShare"
)

Write-Host "=== VPN Status Check ===" -ForegroundColor Cyan
Write-Host ""

# WiFi Status Check
Write-Host "WiFi Information:" -ForegroundColor Yellow
$wifiInterface = netsh wlan show interfaces
$ssidLine = $wifiInterface | Select-String "SSID" | Select-Object -First 1
$stateLine = $wifiInterface | Select-String "State"
$signalLine = $wifiInterface | Select-String "Signal"

if ($ssidLine) {
    Write-Host "  $ssidLine"
    if ($WifiSSID) {
        if ($ssidLine -match $WifiSSID) {
            Write-Host "  [Target WiFi Detected]" -ForegroundColor Green
        } else {
            Write-Host "  [Not Target WiFi]" -ForegroundColor Yellow
        }
    }
}
if ($stateLine) {
    Write-Host "  $stateLine"
}
if ($signalLine) {
    Write-Host "  $signalLine"
}

Write-Host ""

# VPN Status Check
Write-Host "VPN Information:" -ForegroundColor Yellow
Write-Host "  Checking VPN: $VpnName" -ForegroundColor Cyan
try {
    $vpn = Get-VpnConnection -Name $VpnName -ErrorAction Stop
    Write-Host "  Name: $($vpn.Name)"
    Write-Host "  Status: $($vpn.ConnectionStatus)" -ForegroundColor $(if ($vpn.ConnectionStatus -eq "Connected") { "Green" } else { "Red" })
    Write-Host "  Server: $($vpn.ServerAddress)"
    Write-Host "  Tunnel Type: $($vpn.TunnelType)"
    Write-Host "  Remember Credential: $($vpn.RememberCredential)"
} catch {
    Write-Host "  VPN connection '$VpnName' not found" -ForegroundColor Red
}

Write-Host ""

# Task Scheduler Check
Write-Host "Auto-start Configuration:" -ForegroundColor Yellow
$taskNamePattern = "AutoConnectVPN_$VpnName"
try {
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "AutoConnectVPN_*" }
    if ($tasks) {
        foreach ($task in $tasks) {
            Write-Host "  Task Name: $($task.TaskName)"
            Write-Host "  State: $($task.State)" -ForegroundColor $(if ($task.State -eq "Ready") { "Green" } else { "Yellow" })
            Write-Host "  Description: $($task.Description)"
            Write-Host ""
        }
    } else {
        Write-Host "  No auto-start tasks configured" -ForegroundColor Red
        Write-Host "  Run Install-AutoStart.bat as administrator to configure" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  Error checking auto-start configuration" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Check Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
