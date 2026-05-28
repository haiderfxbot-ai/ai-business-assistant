# AI Business Assistant

🚀 WhatsApp Business Automation App with AI-powered smart replies, voice commands, order management, and offline AI support.

## Features
- **AI Auto Replies** - Template, Local AI, Cloud AI (Groq/Gemini)
- **Voice Assistant** - Urdu + English speech support
- **Order Management** - Create, track, manage orders
- **Customer Management** - Track customer history
- **OCR Scanner** - Receipt scanning, QR codes
- **Offline AI** - Local AI via Gemma/TinyLlama/Phi
- **Business Dashboard** - Analytics & insights
- **Smart Notifications** - FCM push notifications
- **Dark/Light Mode** - Modern glass UI

## Tech Stack
- **Frontend:** Flutter (Android + iOS)
- **Backend:** Node.js + Express
- **Database:** Firebase Firestore
- **Auth:** Firebase Auth (Email, Google, Phone)
- **AI APIs:** Groq (primary), Gemini (fallback)
- **Local AI:** Gemma 2B / TinyLlama / Phi via MLC LLM
- **Voice:** Android Speech + Vosk
- **OCR:** Google ML Kit
- **Storage:** Firebase Storage + Cloudinary
- **Notifications:** Firebase FCM
- **Hosting:** Render

## Architecture
```
Simple query → Template reply
Medium query → Local AI (Gemma/TinyLlama/Phi)
Complex query → Cloud AI (Groq → Gemini fallback)
```

## Setup

### Prerequisites
- Flutter SDK 3.0+
- Node.js 18+
- Firebase project

### Installation

```bash
# Frontend
cd frontend
flutter pub get
flutter run

# Backend
cd backend
npm install
cp .env.example .env
npm start
```

### Firebase Setup
1. Create Firebase project
2. Enable Auth (Email, Google, Phone)
3. Create Firestore database
4. Add Android app with package `com.aibusiness.assistant`
5. Download `google-services.json` to `frontend/android/app/`
6. Generate Admin SDK JSON to `backend/`

## Deployment
- Backend: Deploy to Render
- Frontend: Build APK with `flutter build apk`
- Firebase: Deploy rules and functions

## License
MIT
