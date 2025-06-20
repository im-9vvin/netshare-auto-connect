@echo off
chcp 65001 > nul
title Quick Start - VPN Auto Connect for DIRECT-NS-9vvin

echo ========================================
echo  Quick Start for DIRECT-NS-9vvin
echo ========================================
echo.
echo This will set up auto-connect for:
echo   WiFi: DIRECT-NS-9vvin
echo   VPN: NetShare
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause > nul

call "%~dp0Install-AutoStart.bat" "DIRECT-NS-9vvin" "NetShare"
