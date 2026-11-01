@echo off
TITLE Upload Birthday App to GitHub
echo ==========================================================
echo 🚀 One-Click GitHub Uploader for Birthday Reminder App
echo ==========================================================
echo.

cd /d "%~dp0"

:: Initialize Git if not already done
if not exist ".git" (
    echo [1/4] Initializing Git repository...
    git init
) else (
    echo [1/4] Git repository already initialized.
)

echo [2/4] Adding all project files...
git add .

echo [3/4] Creating initial commit...
git commit -m "Initial commit: Automated Birthday Reminder App" 2>nul || echo Changes already committed.

echo.
echo ==========================================================
echo Please create a new repository on GitHub:
echo 1. Open https://github.com/new
echo 2. Type repository name (e.g. birthday-reminder-app)
echo 3. Do NOT check README, gitignore, or license!
echo 4. Click 'Create repository'
echo ==========================================================
echo.
set /p REPO_URL="Paste your GitHub Repository URL here (e.g. https://github.com/username/birthday-reminder-app.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] No URL entered. Aborted.
    pause
    exit /b
)

echo.
echo [4/4] Linking and pushing to GitHub...
git branch -M main
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git push -u origin main

echo.
echo ==========================================================
echo [SUCCESS] Your code is now live on GitHub!
echo Next step: Deploy on Render.com using this GitHub repository.
echo ==========================================================
pause
