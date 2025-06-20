@echo off
chcp 65001 > nul
title Stop VPN Auto Connect

echo ========================================
echo  Stop VPN Auto Connect Tasks
echo ========================================
echo.

if "%~1"=="" (
    echo This will stop and disable ALL VPN auto-connect tasks.
    echo.
    echo To stop a specific VPN:
    echo   Stop-AutoConnect.bat "VPN_Name"
    echo.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Stop-AutoConnect.ps1"
) else (
    set VPN_NAME=%~1
    echo Stopping auto-connect for VPN: %VPN_NAME%
    echo.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Stop-AutoConnect.ps1" -VpnName "%VPN_NAME%"
)
