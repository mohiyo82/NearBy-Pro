# 📱 NearBy Pro – Smart Location & Career Finder

A professional, fully functional **Flutter Android application** — featuring smart location discovery, career opportunities, and business management.

---

## 🎨 Design System

| Property | Value |
|---|---|
| Primary Color | Green `#2E7D32` |
| Secondary | Azure Blue `#0288D1` |
| Background | White `#FFFFFF` |
| UI Style | Material Design 3 · Clean Modern · Responsive Cards |

---

## ✨ Key Features

- **🔐 Robust Auth:** Email/Password & Google Sign-In via Firebase.
- **💼 Dual Mode:** Switch between Personal (User) and Business (Company) modes.
- **📍 Smart Discovery:** Find nearby Hospitals, Schools, Software Houses, and more.
- **🚀 Job Portal:** Companies can post jobs, manage applicants, and track profile views.
- **📊 Real-time Analytics:** Track profile performance and user interactions.
- **💳 Pro Subscriptions:** Integrated payment methods (Easypaisa, JazzCash, Meezan, Card).
- **📄 AI Resume Builder:** Generate professional CVs from user profile data.

---

## 📁 Project Structure

```
lib/
├── main.dart                    ← App Entry, Firebase Init & Routes
├── theme/
│   └── app_theme.dart           ← Brand Colors & Global ThemeData
├── services/
│   ├── auth_service.dart        ← Firebase Auth & Social Login
│   ├── database_service.dart    ← Firestore Logic & Analytics
│   └── cloudinary_service.dart  ← Image/Media Hosting
└── screens/
    ├── 🔐 auth/                  ← Login, Signup, Splash, Logout
    ├── 🏠 home/                  ← MainWrapper (Bottom Nav), Dashboard
    ├── 🏢 company/               ← Business Dashboard, Job Posting, Applicants
    ├── 👤 profile/               ← Resume Manager, Analytics, Profile Setup
    ├── 🔍 search/                ← Global Search, Map Location Picker
    ├── ⚙️ settings/              ← Preferences, Payments, Notifications
    └── 📍 results/               ← Map/List Views, Job Details, Saved Places
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Firebase Project (google-services.json)
- Google Maps API Key

### Setup

```bash
# Get dependencies
flutter pub get

# Setup Firebase (if not configured)
flutterfire configure

# Run the app
flutter run
```

---

## 🧭 Main Navigation Routes

| Route | Function |
|---|---|
| `/splash` | Animated App Intro |
| `/home` | Dynamic Bottom Nav Wrapper |
| `/login` | User Authentication |
| `/company-dashboard` | Business Control Center |
| `/manage-applicants` | Recruitment Management |
| `/profile-analytics` | Performance Metrics |
| `/payment-method` | Financial Settings |
| `/help-tutorial` | App Usage Guide |

---

## 🛠️ Technology Stack

- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Auth, Storage)
- **State Management:** Provider
- **Media Hosting:** Cloudinary
- **Maps:** Google Maps Flutter
- **Documents:** PDF & Printing packages

---

*NearBy Pro © 2025 — Production Ready v1.1.0*
