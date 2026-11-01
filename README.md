# 🎂 Automated Birthday Notification & Profile Management System

> **Enterprise Architecture:** Node.js Frontend + Python FastAPI Backend + AES-256-GCM Cryptographic Vault + Google Calendar 9:00 AM Morning Reminders.

---

## 🌟 Executive Overview & Key Features

This project delivers a **secure, user-friendly, and automated birthday notification system** designed according to senior engineering best practices.

### 1. 📊 Excel Database Upload & Ingestion
- Upload `.xlsx`, `.xls`, or `.csv` files containing:
  - **Name** of the person
  - **Date of Birth (DOB)** (supports `YYYY-MM-DD`, `DD/MM/YYYY`, `MM-DD-YYYY`, and Excel serial numbers)
  - **Image / Photo** (image URLs, local paths, or base64 data)
  - **Google ID / Email** and **Notes/Relationship**
- Intelligent header matching (tolerant of uppercase, lowercase, spaces, and column synonyms).
- Built-in downloadable **Excel Template (`birthday_template.xlsx`)** with sample rows.

### 2. 🎨 Interactive JPEG Image Editor & Profile Management
- **Delete Directly from UI**: Delete any profile with a single click and safety confirmation modal.
- **Edit Profiles in UI**: Update Name, Date of Birth, Email, and Notes directly from the browser.
- **In-Browser JPEG Image Editor**:
  - Live **HTML5 Canvas** editor.
  - Upload new JPEG/PNG photos or edit existing avatars.
  - **Pan & Drag** positioning with mouse or touchscreen.
  - **Zoom Slider** (0.5x to 3.0x scale).
  - **Rotate 90°** counter-clockwise and clockwise.
  - **Brightness & Contrast** enhancement controls.
  - **Circle & Square Framing Guides**.
  - **Lossless JPEG Export** at high fidelity.

### 3. 📅 Google Calendar Morning Notification Sync
- **9:00 AM Morning Reminders**: Configured with `RRULE:FREQ=YEARLY` recurrence so it alerts you on time every year.
- **1-Click Instant Web Sync**: Click "Sync Cal" on any profile to open a pre-filled Google Calendar event template without needing complex API keys.
- **RFC 5545 iCalendar (`.ics`) Feed**: Google Calendar subscription link (`/api/calendar/feed.ics`) to keep all celebrants synced automatically across mobile, tablet, and desktop.
- **Direct Google Calendar API (v3)**: Authenticated sync via OAuth2 / Service Account (`credentials.json`).

### 4. 🔒 Enterprise AES-256-GCM Cryptographic Security
- **Cipher**: AES-256 in Galois/Counter Mode (GCM) providing **Authenticated Encryption with Associated Data (AEAD)**.
- **Integrity Verification**: 16-byte authentication tag verified on every decryption. Any modification or tampering causes instant rejection.
- **Key Derivation**: PBKDF2 with HMAC-SHA256 and **100,000 iterations** using a cryptographically secure 16-byte random salt.
- **Zero IV Reuse**: Every encrypted record receives a fresh, cryptographically secure 96-bit random initialization vector (`os.urandom(12)`).
- **Encrypted At Rest**: Names, birthdates, emails, and notes are encrypted before touching the disk.

### 5. ⏰ Automated Background Notification Scheduler
- Automated morning background job runs daily at **09:00 AM** (configurable via `REMINDER_HOUR` and `REMINDER_MINUTE`).
- Alerts today's celebrants, logs to the audit table, and highlights celebrants on the UI dashboard with celebratory confetti.

---

## 🏗️ Architecture Layout

```
birthday-reminder-app/
├── run.bat                          # Windows 1-Click Startup Script
├── run.sh                           # Linux/macOS Startup Script
├── README.md                        # Documentation & Architecture Guide
├── sample_data/
│   └── sample_birthdays.csv         # Ready-to-import sample dataset
├── backend/                         # Python Backend Service
│   ├── app.py                       # FastAPI REST API & routes
│   ├── config.py                    # App configuration & reminder settings
│   ├── crypto.py                    # AES-256-GCM authenticated encryption engine
│   ├── database.py                  # Encrypted SQLite persistence layer
│   ├── excel_parser.py              # Excel (.xlsx/.xls) & CSV ingestion engine
│   ├── google_calendar.py           # Google Calendar API, 1-Click URLs, & iCal feeds
│   ├── scheduler.py                 # Daily morning alert background scheduler
│   └── requirements.txt             # Python dependencies
└── frontend/                        # Node.js UI Application
    ├── package.json                 # Node.js server dependencies
    ├── server.js                    # Express frontend server & reverse proxy
    └── public/
        ├── index.html               # Responsive web UI with Tailwind & Lucide icons
        ├── css/
        │   └── styles.css           # Glassmorphism, animations & styling
        └── js/
            ├── app.js               # Main SPA logic: upload, delete, edit, countdowns
            └── imageEditor.js       # Interactive HTML5 Canvas JPEG Editor
```

---

## 🚀 Quick Start Guide

### Option 1: 1-Click Launch (Windows)
Double-click `run.bat` or run in terminal:
```cmd
run.bat
```
This automatically initializes the virtual environment, installs packages, launches both backend and frontend servers, and opens `http://localhost:3000` in your default browser.

---

### Option 2: Step-by-Step Manual Launch

#### Step 1: Start Python Backend
```bash
cd backend
pip install -r requirements.txt
python app.py
```
> Backend runs at `http://127.0.0.1:8000`. Interactive Swagger API docs are available at `http://127.0.0.1:8000/docs`.

#### Step 2: Start Node.js Frontend
In a new terminal window:
```bash
cd frontend
npm install
npm start
```
> Web application opens at `http://localhost:3000`.

---

## 📖 Usage Instructions

1. **Upload Excel Database**:
   - Click the **"Upload Excel"** button on the top right.
   - Drag & drop `sample_data/sample_birthdays.csv` or your own Excel spreadsheet (`.xlsx`).
   - The app parses each row, runs date normalization, encrypts personal data with AES-256-GCM, and populates the dashboard.

2. **Edit a Profile & Crop JPEG**:
   - Click the **"Edit"** button on any profile card.
   - Edit Name, Date of Birth, Email, or Notes.
   - In the right-hand canvas, pan, zoom, or rotate the person's photo, or click **"Upload New JPEG"** to load a new image from your computer.
   - Click **"Save Changes"** — the cropped JPEG is saved and profile data is re-encrypted.

3. **Delete a Profile**:
   - Click the red trash icon on any profile card.
   - Confirm deletion in the modal dialog — the record and image are wiped from the database.

4. **Sync with Google Calendar**:
   - Click **"Sync Cal"** on any celebrant's card.
   - A Google Calendar event tab opens with:
     - 🎂 Celebrant's Name and Birthday details
     - Event time: 09:00 AM (Morning reminder)
     - Recurrence: `RRULE:FREQ=YEARLY`
   - To subscribe to all birthdays at once, click **"iCal Feed"** in the top navigation and add the URL into Google Calendar under *Other Calendars -> From URL*.

5. **Test Morning Notification Alert**:
   - Click **"Test Morning Alert"** in the top navigation.
   - The system executes the morning alert routine and reports today's celebrants.

---

## 🔒 Cryptographic Implementation Details

The encryption system in [`backend/crypto.py`](file:///C:/Users/aswin/.gemini/antigravity/scratch/birthday-reminder-app/backend/crypto.py) follows rigorous cryptographic guidelines:

| Property | Implementation | Security Purpose |
| :--- | :--- | :--- |
| **Algorithm** | `AES-256-GCM` | Authenticated Encryption with Associated Data (AEAD) |
| **Key Size** | 256 bits (32 bytes) | Resistant to brute-force attacks |
| **Nonce / IV** | 96 bits (`os.urandom(12)`) | Fresh random IV per record; zero nonce-reuse risk |
| **Authentication Tag** | 128 bits (16 bytes) | Detects any ciphertext tampering or bit-flipping |
| **Key Derivation** | PBKDF2-HMAC-SHA256 | 100,000 iterations + 16-byte cryptographically secure salt |

---

## 🌐 API Reference Overview

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/health` | Health check, AES-256-GCM verification & scheduler status |
| `GET` | `/api/stats` | Counts for total celebrants, today, next 7 days, this month |
| `GET` | `/api/profiles` | List all profiles (decrypted & sorted by upcoming days) |
| `POST` | `/api/profiles` | Create a new profile with AES-256-GCM encryption |
| `PUT` | `/api/profiles/{id}` | Update profile details and re-encrypt |
| `DELETE` | `/api/profiles/{id}` | Permanently delete profile and avatar file |
| `POST` | `/api/upload/excel` | Ingest Excel (`.xlsx`, `.xls`, `.csv`) spreadsheet |
| `GET` | `/api/template/excel` | Download pre-formatted Excel template |
| `POST` | `/api/upload/image` | Upload & store edited JPEG avatar |
| `GET` | `/api/profiles/{id}/google-calendar-url` | Generate 1-click Google Calendar 9 AM reminder URL |
| `GET` | `/api/calendar/feed.ics` | RFC 5545 iCalendar feed for Google Calendar subscription |
| `POST` | `/api/reminders/trigger` | Manually fire morning notification alert dispatch |
