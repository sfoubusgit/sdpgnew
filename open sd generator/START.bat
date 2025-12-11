@echo off
REM Simple launcher - double-click this file to start everything
cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "start-dev-and-open.ps1"
pause






