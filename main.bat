@echo off
chcp 65001 > NUL
echo .
echo ███╗   ███╗ █████╗  ██████╗███████╗ ██████╗ 
echo ████╗ ████║██╔══██╗██╔════╝██╔════╝██╔════╝ 
echo ██╔████╔██║███████║██║     █████╗  ██║  ███╗
echo ██║╚██╔╝██║██╔══██║██║     ██╔══╝  ██║   ██║
echo ██║ ╚═╝ ██║██║  ██║╚██████╗██║     ╚██████╔╝
echo ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝      ╚═════╝ 
echo desc: configure my env • version: 0.1.0

:: Self-elevate if not already running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Relancement en mode administrateur...
    powershell -command "start-process '%~f0' -verb runas"
    exit /b
)

powershell.exe -Command "Get-ChildItem -Path '%~dp0scripts\*.ps1' | Unblock-File"
powershell.exe -ExecutionPolicy Bypass -File "%~dp0scripts\main.ps1"
pause
