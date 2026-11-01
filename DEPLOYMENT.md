# 🚀 Production Deployment & Hosting Guide

This project is fully packaged, containerized, and ready to deploy on any cloud platform or VPS in minutes.

---

## 🌟 Supported Hosting Platforms

| Platform | Deployment Method | Estimated Time | Cost Tier |
| :--- | :--- | :--- | :--- |
| **Docker / VPS** | `docker compose up -d` | 2 mins | Any server ($5/mo or existing) |
| **Render.com** | 1-Click Blueprint (`render.yaml`) | 3 mins | **Free** |
| **Railway.app** | Git Push / `Dockerfile` | 2 mins | $5 Free credit / mo |
| **Google Cloud Run** | Container Image | 3 mins | Generous Free Tier |
| **Local Machine** | Double-click `start_server.bat` | 5 seconds | Free |

---

## 🐳 1. Deploy with Docker (Recommended for VPS / Server)

The application comes with an optimized, production-ready `Dockerfile` and `docker-compose.yml`.

### Step 1: Clone or Copy Project onto Server
```bash
git clone <your-repo-url> birthday-app
cd birthday-app
```

### Step 2: Launch with Docker Compose
```bash
docker compose up -d --build
```

### Step 3: Verify Deployment
Your app is live at:
```text
http://<your-server-ip>:8000
```
- Web UI: `http://<your-server-ip>:8000`
- REST API & Health Check: `http://<your-server-ip>:8000/api/health`
- Swagger Docs: `http://<your-server-ip>:8000/docs`
- Encrypted SQLite DB is persisted across restarts in the `birthday_data` Docker volume.

---

## ☁️ 2. Deploy to Render.com (1-Click Free Hosting)

1. Push your project to a GitHub or GitLab repository.
2. Sign in to [Render.com](https://render.com).
3. Click **"New +"** -> **"Blueprint"**.
4. Connect your repository.
5. Render detects [`render.yaml`](file:///C:/Users/aswin/.gemini/antigravity/scratch/birthday-reminder-app/render.yaml) automatically and configures:
   - Environment: Python 3.11
   - Build Command: `pip install -r backend/requirements.txt`
   - Start Command: `cd backend && uvicorn app:app --host 0.0.0.0 --port $PORT`
6. Click **"Apply"**. Your app will be live with a free SSL `https://<your-app>.onrender.com` URL!

---

## 🚂 3. Deploy to Railway.app

1. Install Railway CLI or use the web dashboard at [railway.app](https://railway.app).
2. Click **"New Project"** -> **"Deploy from GitHub repo"**.
3. Select this repository.
4. Railway will automatically pick up the [`Dockerfile`](file:///C:/Users/aswin/.gemini/antigravity/scratch/birthday-reminder-app/Dockerfile) or [`Procfile`](file:///C:/Users/aswin/.gemini/antigravity/scratch/birthday-reminder-app/Procfile).
5. Add a volume mount for `/app/backend/data` under **Settings -> Volumes** for persistent encrypted storage.
6. Generate a public domain under **Settings -> Networking**.

---

## ☁️ 4. Deploy to Google Cloud Run

```bash
# 1. Build and push container to Google Artifact Registry
gcloud builds submit --tag gcr.io/[PROJECT_ID]/birthday-reminder

# 2. Deploy to Cloud Run
gcloud run deploy birthday-reminder \
  --image gcr.io/[PROJECT_ID]/birthday-reminder \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8000
```

---

## 💻 5. Run Locally on Windows Instantly (Zero Dependencies)

If you just want to run and test it on your local machine right now:
1. Double-click [`start_server.bat`](file:///C:/Users/aswin/.gemini/antigravity/scratch/birthday-reminder-app/start_server.bat).
2. It launches the native Windows HTTP server and immediately opens `http://localhost:3000` in your browser.
3. All **53 celebrants** are loaded and ready for searching, editing JPEG photos, deleting, and syncing with Google Calendar.
