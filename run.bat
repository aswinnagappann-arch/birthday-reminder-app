@echo off
TITLE Birthday Reminder & Notification System
echo ==========================================================
echo 🎂 Birthday Reminder & Automated Morning Notification System
echo ==========================================================

cd /d "%~dp0"

echo [1/3] Checking Python Backend...
cd backend
if not exist "venv" (
    echo Creating Python virtual environment...
    python -m venv venv 2>nul || py -m venv venv 2>nul
)
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
    echo Installing backend dependencies...
    pip install -r requirements.txt
) else (
    echo Note: Using system Python environment...
    pip install -r requirements.txt 2>nul
)

start "Birthday Backend (Python FastAPI)" cmd /k "cd /d %~dp0backend && uvicorn app:app --host 127.0.0.1 --port 8000 --reload"

echo [2/3] Checking Node.js Frontend...
cd /d "%~dp0frontend"
if not exist "node_modules" (
    echo Installing Node.js dependencies...
    call npm install 2>nul
)

start "Birthday Frontend (Node.js)" cmd /k "cd /d %~dp0frontend && node server.js"

echo [3/3] Launching Web Application in Browser...
timeout /t 3 >nul
start http://localhost:3000

echo ==========================================================
echo [OK] Both Services are running!
echo Frontend: http://localhost:3000
echo Backend API: http://127.0.0.1:8000/docs
echo ==========================================================
