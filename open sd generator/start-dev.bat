@echo off
REM Batch file to start dev server in CMD and open Chrome
set PROJECT_PATH=C:\Users\Sina\Desktop\PCV1_new
set SCRIPT_PATH=%~dp0

REM Change to project directory and start npm run dev in a new CMD window
start cmd /k "cd /d %PROJECT_PATH% && npm run dev"

REM Wait a few seconds for server to start
timeout /t 5 /nobreak >nul

REM Run PowerShell script to extract URL and open Chrome
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_PATH%open-chrome.ps1"






