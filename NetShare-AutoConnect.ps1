# NetShare VPN Auto Connect Monitoring Script
# Created: 2025-06-20
# Description: Automatically connects VPN when connected to specific WiFi
# Usage: .\NetShare-AutoConnect.ps1 -WifiSSID "YourWiFiName" [-VpnName "YourVPNName"]

param(
    [Parameter(Mandatory=$true)]
    [string]$WifiSSID,
    
    [Parameter(Mandatory=$false)]
    [string]$VpnName = "NetShare"
)

# === Configuration ===
$targetSSID = $WifiSSID
$vpnName = $VpnName
$checkInterval = 3  # Check interval in seconds
$logFile = "$PSScriptRoot\VPN-AutoConnect-$($VpnName).log"

# === Function Definitions ===
function Write-Log {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Type] $Message"
    
    # Write to log file
    Add-Content -Path $logFile -Value $logMessage -ErrorAction SilentlyContinue
    
    # Display in console
    switch ($Type) {
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "INFO" { Write-Host $logMessage -ForegroundColor Cyan }
        default { Write-Host $logMessage -ForegroundColor White }
    }
}

function Get-CurrentWiFiSSID {
    try {
        $wifiInfo = netsh wlan show interfaces | Select-String "SSID" -Context 0,1
        foreach ($line in $wifiInfo) {
            if ($line.Line -match "SSID\s*:\s*(.+)$") {
                $ssid = $matches[1].Trim()
                # Return only SSID, not BSSID
                if (-not ($ssid -match "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")) {
                    return $ssid
                }
            }
        }
        return $null
    } catch {
        Write-Log "Error checking WiFi SSID: $_" "ERROR"
        return $null
    }
}

function Test-VPNConnection {
    param([string]$VpnName)
    
    try {
        $vpn = Get-VpnConnection -Name $VpnName -ErrorAction SilentlyContinue
        if ($vpn) {
            return $vpn.ConnectionStatus
        }
        return "NotFound"
    } catch {
        return "Error"
    }
}

function Connect-NetShareVPN {
    param([string]$VpnName)
    
    try {
        Write-Log "Attempting VPN connection: $VpnName" "INFO"
        
        # Check VPN profile
        $vpn = Get-VpnConnection -Name $VpnName -ErrorAction Stop
        
        if ($vpn.ConnectionStatus -eq "Connected") {
            Write-Log "VPN is already connected" "INFO"
            return $true
        }
        
        # Check RememberCredential
        if (-not $vpn.RememberCredential) {
            Write-Log "No saved credentials. Authentication may be required" "WARNING"
        }
        
        # Connect using rasdial
        $result = & rasdial $VpnName 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "VPN connection successful!" "SUCCESS"
            return $true
        } else {
            Write-Log "VPN connection failed: $result" "ERROR"
            return $false
        }
    } catch {
        Write-Log "Error during VPN connection: $_" "ERROR"
        return $false
    }
}

function Disconnect-NetShareVPN {
    param([string]$VpnName)
    
    try {
        Write-Log "Attempting VPN disconnection: $VpnName" "INFO"
        $result = & rasdial $VpnName /disconnect 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "VPN disconnection successful" "SUCCESS"
            return $true
        } else {
            Write-Log "VPN disconnection failed: $result" "ERROR"
            return $false
        }
    } catch {
        Write-Log "Error during VPN disconnection: $_" "ERROR"
        return $false
    }
}

# === Main Script Start ===
Write-Log "========================================" "INFO"
Write-Log "VPN Auto Connect Monitor Started" "INFO"
Write-Log "Target WiFi: $targetSSID" "INFO"
Write-Log "VPN Name: $vpnName" "INFO"
Write-Log "Check Interval: $checkInterval seconds" "INFO"
Write-Log "========================================" "INFO"

# Initial status check
$currentSSID = Get-CurrentWiFiSSID
$vpnStatus = Test-VPNConnection -VpnName $vpnName

Write-Log "Initial WiFi status: $currentSSID" "INFO"
Write-Log "Initial VPN status: $vpnStatus" "INFO"

# Monitoring loop
$lastSSID = ""
$lastVPNStatus = ""

while ($true) {
    try {
        # Check current WiFi SSID
        $currentSSID = Get-CurrentWiFiSSID
        $vpnStatus = Test-VPNConnection -VpnName $vpnName
        
        # Detect status changes
        $ssidChanged = $currentSSID -ne $lastSSID
        $vpnChanged = $vpnStatus -ne $lastVPNStatus
        
        if ($ssidChanged -or $vpnChanged) {
            Write-Log "Status change detected - WiFi: $currentSSID, VPN: $vpnStatus" "INFO"
        }
        
        # If connected to target WiFi
        if ($currentSSID -eq $targetSSID) {
            if ($vpnStatus -eq "Disconnected") {
                Write-Log "Target WiFi detected. Starting VPN connection..." "INFO"
                $connected = Connect-NetShareVPN -VpnName $vpnName
                
                if ($connected) {
                    # Wait for connection confirmation
                    Start-Sleep -Seconds 3
                    $vpnStatus = Test-VPNConnection -VpnName $vpnName
                    Write-Log "VPN final status: $vpnStatus" "INFO"
                }
            }
        } else {
            # Connected to different WiFi or no WiFi
            if ($vpnStatus -eq "Connected") {
                Write-Log "Not on target WiFi. Disconnecting VPN..." "INFO"
                Disconnect-NetShareVPN -VpnName $vpnName
            }
        }
        
        # Save current status
        $lastSSID = $currentSSID
        $lastVPNStatus = $vpnStatus
        
    } catch {
        Write-Log "Monitoring loop error: $_" "ERROR"
    }
    
    # Wait for next check
    Start-Sleep -Seconds $checkInterval
}
