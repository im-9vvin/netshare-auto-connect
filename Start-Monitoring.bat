@echo off
chcp 65001 > nul
title VPN Auto Connect Monitor

echo ========================================
echo  VPN Auto Connect Monitor
echo ========================================
echo.

if "%~1"=="" (
    echo ERROR: WiFi SSID is required!
    echo.
    echo Usage: Start-Monitoring.bat "WiFi_SSID" [VPN_Name]
    echo.
    echo Example:
    echo   Start-Monitoring.bat "DIRECT-NS-9vvin"
    echo   Start-Monitoring.bat "DIRECT-NS-9vvin" "NetShare"
    echo.
    pause
    exit /b 1
)

set WIFI_SSID=%~1
set VPN_NAME=%~2

if "%VPN_NAME%"=="" (
    set VPN_NAME=NetShare
)

echo Target WiFi: %WIFI_SSID%
echo VPN Name: %VPN_NAME%
echo.
echo Starting script...
echo Press Ctrl+C to stop.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0NetShare-AutoConnect.ps1" -WifiSSID "%WIFI_SSID%" -VpnName "%VPN_NAME%"

pause
