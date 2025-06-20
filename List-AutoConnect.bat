@echo off
chcp 65001 > nul
title List VPN Auto Connect Tasks

echo ========================================
echo  List VPN Auto Connect Tasks
echo ========================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0List-AutoConnect.ps1"
