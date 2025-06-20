[English](README.md) | [한국어](README.ko.md)

# VPN Auto Connect Script

This script automatically connects to a specified VPN when connected to a specific WiFi network.

## 🎯 Why This Script Was Created

**NetShare VPN requires manual reconnection every time:**
- ❌ When your computer wakes from sleep mode
- ❌ When you restart your computer
- ❌ When WiFi connection is restored

**This script solves these inconveniences by:**
- ✅ Automatically detecting WiFi connection
- ✅ Automatically reconnecting VPN without user intervention
- ✅ Running seamlessly in the background
- ✅ Maintaining VPN connection across sleep/wake cycles

## 📋 Prerequisites

1. Windows 11 operating system
2. VPN connection already configured in Windows
3. VPN credentials saved in Windows Credential Manager

## ⭐ Key Features

- **No more manual reconnections** - Automatically handles VPN reconnection after sleep mode
- **Seamless experience** - Works silently in the background without user intervention
- **Smart detection** - Monitors WiFi changes and responds instantly
- **Multiple VPN support** - Configure different VPNs for different WiFi networks
- **Flexible control** - Easy to pause, resume, or remove auto-connect functionality

## 📁 File Structure

- `NetShare-AutoConnect.ps1` - Main monitoring script
- `Install-TaskScheduler.ps1` - Task Scheduler registration script
- `Start-Monitoring.bat` - Manual execution batch file
- `Install-AutoStart.bat` - Auto-start installation batch file
- `Check-Status.bat` - Status check batch file
- `List-AutoConnect.bat` - List all auto-connect tasks
- `Stop-AutoConnect.bat` - Stop and disable tasks
- `Enable-AutoConnect.bat` - Enable disabled tasks
- `Remove-AllAutoConnect.bat` - Remove all tasks permanently
- `QuickStart-9vvin.bat` - Quick setup for DIRECT-NS-9vvin network
- `VPN-AutoConnect-[VPN_Name].log` - Execution log file (auto-generated)

## 🚀 Installation

### Method 1: Auto-start Setup (Recommended)

1. Run `Install-AutoStart.bat` with **administrator privileges**:
   - Right-click the file → Select "Run as administrator"
   
2. Provide required parameters:
   ```
   Install-AutoStart.bat "WiFi_SSID" [VPN_Name]
   ```
   
   Examples:
   ```
   Install-AutoStart.bat "DIRECT-NS-9vvin"
   Install-AutoStart.bat "DIRECT-NS-9vvin" "NetShare"
   Install-AutoStart.bat "MyHomeWiFi" "WorkVPN"
   ```

### Method 2: Manual Execution

1. Run `Start-Monitoring.bat` with parameters:
   ```
   Start-Monitoring.bat "WiFi_SSID" [VPN_Name]
   ```
   
   Examples:
   ```
   Start-Monitoring.bat "DIRECT-NS-9vvin"
   Start-Monitoring.bat "DIRECT-NS-9vvin" "NetShare"
   ```

2. The script will monitor in the background
3. Press `Ctrl+C` to stop

## ⚙️ Parameters

### Required Parameters:
- **WiFi_SSID**: The name of the WiFi network that triggers VPN connection

### Optional Parameters:
- **VPN_Name**: Name of the VPN connection (default: "NetShare")

## 🔍 Status Check

Check current WiFi and VPN status:

```
Check-Status.bat [WiFi_SSID] [VPN_Name]
```

Examples:
```
Check-Status.bat                           # Check all VPNs
Check-Status.bat "DIRECT-NS-9vvin"         # Check specific WiFi with default VPN
Check-Status.bat "DIRECT-NS-9vvin" "NetShare"  # Check specific WiFi and VPN
```

## 🔧 Configuration

The monitoring script checks every 30 seconds. To change this, edit the `$checkInterval` variable in `NetShare-AutoConnect.ps1`.

## 📝 How It Works

1. The script monitors your computer's network status every 30 seconds
2. When it detects connection to the specified WiFi network, it automatically connects the VPN
3. When you disconnect from the WiFi or switch networks, it disconnects the VPN
4. **Special handling for sleep/wake cycles**: The script continues monitoring after your computer wakes from sleep, automatically reconnecting the VPN
5. All activities are logged to `VPN-AutoConnect-[VPN_Name].log`

This eliminates the frustration of manually reconnecting NetShare VPN after every sleep mode or computer restart!

## 🛠️ Troubleshooting

### VPN doesn't connect automatically

1. Verify VPN is configured in Windows Settings:
   - Settings → Network & Internet → VPN
   
2. Ensure credentials are saved:
   - Check "Remember my sign-in info" when connecting
   
3. Check the log file: `VPN-AutoConnect-[VPN_Name].log`

### Task Scheduler registration fails

1. Ensure running with administrator privileges
2. Check Windows Defender/antivirus isn't blocking
3. Verify PowerShell execution policy:
   ```powershell
   Get-ExecutionPolicy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### Multiple VPN configurations

You can set up multiple auto-connect tasks for different WiFi/VPN combinations:

```
Install-AutoStart.bat "HomeWiFi" "PersonalVPN"
Install-AutoStart.bat "OfficeWiFi" "WorkVPN"
Install-AutoStart.bat "CafeWiFi" "SecureVPN"
```

Each configuration will create a separate task in Task Scheduler.

## 🎛️ Task Management

### List all auto-connect tasks:
```
List-AutoConnect.bat
```
Shows all configured VPN auto-connect tasks with their status, last run time, and next run time.

### Stop/Disable tasks:
```
Stop-AutoConnect.bat                    # Stop and disable all tasks
Stop-AutoConnect.bat "VPN_Name"         # Stop and disable specific VPN
```
This stops running tasks and disables them from automatic startup.

### Enable/Restart tasks:
```
Enable-AutoConnect.bat                  # Enable all disabled tasks
Enable-AutoConnect.bat "VPN_Name"       # Enable specific VPN
```
Re-enables previously disabled tasks and optionally starts them immediately.

## 🗑️ Uninstallation

### Remove specific VPN auto-connect:
1. Open Task Scheduler
2. Find task named "AutoConnectVPN_[VPN_Name]"
3. Right-click → Delete

### Remove via PowerShell:
```powershell
Unregister-ScheduledTask -TaskName "AutoConnectVPN_NetShare" -Confirm:$false
```

## ⚠️ Notes

- The script requires the VPN to be pre-configured in Windows
- Saved credentials are required for automatic connection
- Windows 11 22H2+ may have issues with Credential Guard affecting auto-authentication
- Each VPN configuration creates a separate log file
