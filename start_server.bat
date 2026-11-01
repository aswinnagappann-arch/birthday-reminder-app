@echo off
TITLE Birthday Reminder Web Server
echo ==========================================================
echo 🎂 Launching Birthday Reminder Server on Windows...
echo ==========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start_server.ps1"
pause
