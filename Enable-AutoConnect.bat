@echo off
chcp 65001 > nul
title Enable VPN Auto Connect

echo ========================================
echo  Enable VPN Auto Connect Tasks
echo ========================================
echo.

if "%~1"=="" (
    echo This will enable ALL disabled VPN auto-connect tasks.
    echo.
    echo To enable a specific VPN:
    echo   Enable-AutoConnect.bat "VPN_Name"
    echo.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Enable-AutoConnect.ps1"
) else (
    set VPN_NAME=%~1
    echo Enabling auto-connect for VPN: %VPN_NAME%
    echo.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Enable-AutoConnect.ps1" -VpnName "%VPN_NAME%"
)
