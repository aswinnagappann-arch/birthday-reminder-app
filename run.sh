#!/bin/bash
echo "🎂 Starting Birthday Reminder & Automated Morning Notification System..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Start Python Backend
cd "$DIR/backend"
if [ ! -d "venv" ]; then
    python3 -m venv venv || python -m venv venv
fi
source venv/bin/activate 2>/dev/null || true
pip install -r requirements.txt
uvicorn app:app --host 127.0.0.1 --port 8000 --reload &
BACKEND_PID=$!

# Start Node.js Frontend
cd "$DIR/frontend"
npm install
node server.js &
FRONTEND_PID=$!

echo "Frontend UI: http://localhost:3000"
echo "Backend API: http://127.0.0.1:8000/docs"

wait $BACKEND_PID $FRONTEND_PID
