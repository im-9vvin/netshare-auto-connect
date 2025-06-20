@echo off
chcp 65001 > nul
title VPN Status Check

if "%~1"=="" (
    :: If no parameters, just run status check without specific WiFi/VPN
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Check-Status.ps1"
) else (
    :: If parameters provided, pass them to PowerShell
    set WIFI_SSID=%~1
    set VPN_NAME=%~2
    
    if "%VPN_NAME%"=="" (
        set VPN_NAME=NetShare
    )
    
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Check-Status.ps1" -WifiSSID "%WIFI_SSID%" -VpnName "%VPN_NAME%"
)
