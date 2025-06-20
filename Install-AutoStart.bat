@echo off
chcp 65001 > nul
title VPN Auto Connect - Task Scheduler Install

echo ========================================
echo  VPN Auto Connect Installation
echo ========================================
echo.

if "%~1"=="" (
    echo ERROR: WiFi SSID is required!
    echo.
    echo Usage: Install-AutoStart.bat "WiFi_SSID" [VPN_Name]
    echo.
    echo Example:
    echo   Install-AutoStart.bat "DIRECT-NS-9vvin"
    echo   Install-AutoStart.bat "DIRECT-NS-9vvin" "NetShare"
    echo.
    pause
    exit /b 1
)

set WIFI_SSID=%~1
set VPN_NAME=%~2

if "%VPN_NAME%"=="" (
    set VPN_NAME=NetShare
)

echo WiFi SSID: %WIFI_SSID%
echo VPN Name: %VPN_NAME%
echo.
echo This script requires administrator privileges.
echo.

:: Check administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Administrator privileges required!
    echo.
    echo Please right-click this file and select
    echo "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo OK: Administrator privileges confirmed
echo.
echo Registering task in Task Scheduler...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-TaskScheduler.ps1" -WifiSSID "%WIFI_SSID%" -VpnName "%VPN_NAME%"

pause
