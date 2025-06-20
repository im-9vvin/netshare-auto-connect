@echo off
chcp 65001 > nul
title Remove All VPN Auto Connect Tasks

echo ========================================
echo  Remove All VPN Auto Connect Tasks
echo ========================================
echo.
echo This will remove ALL VPN auto-connect configurations.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Remove-AllAutoConnect.ps1"
