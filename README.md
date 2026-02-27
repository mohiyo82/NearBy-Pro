# 📱 NearBy Pro – Smart Location & Career Finder

A professional **Flutter Android app UI** — 50 screens, clean modern design, production-quality layouts.

---

## 🎨 Design System

| Property | Value |
|---|---|
| Primary Color | Green `#2E7D32` |
| Secondary | Azure Blue `#0288D1` |
| Background | White `#FFFFFF` |
| Text | Dark Gray / Black |
| UI Style | Clean Modern · Google-style spacing · Rounded cards |

---

## 📁 Project Structure

```
lib/
├── main.dart                    ← Entry point + all routes
├── theme/
│   └── app_theme.dart           ← Colors, TextStyles, ThemeData
├── widgets/
│   └── shared_widgets.dart      ← Reusable UI components
└── screens/                     ← 50 individual screen files
    ├── 🔐 AUTH & ONBOARDING (6)
    │   ├── splash_screen.dart
    │   ├── onboarding_screen_1.dart
    │   ├── onboarding_screen_2.dart
    │   ├── onboarding_screen_3.dart
    │   ├── login_screen.dart
    │   └── signup_screen.dart
    │
    ├── 👤 PROFILE SETUP (6)
    │   ├── create_profile_screen.dart
    │   ├── personal_details_screen.dart
    │   ├── education_details_screen.dart
    │   ├── skills_selection_screen.dart
    │   ├── resume_upload_screen.dart
    │   └── profile_preview_screen.dart
    │
    ├── 🏠 MAIN APP FLOW (8)
    │   ├── home_dashboard_screen.dart
    │   ├── global_search_screen.dart
    │   ├── category_selection_screen.dart
    │   ├── city_selection_screen.dart
    │   ├── area_selection_screen.dart
    │   ├── distance_filter_screen.dart
    │   ├── advanced_filters_screen.dart
    │   └── search_results_loading_screen.dart
    │
    ├── 🗺️ SEARCH RESULTS (7)
    │   ├── results_list_view_screen.dart
    │   ├── results_map_view_screen.dart
    │   ├── single_result_card_detail_screen.dart
    │   ├── contact_information_screen.dart
    │   ├── save_result_screen.dart
    │   ├── similar_places_screen.dart
    │   └── empty_result_screen.dart
    │
    ├── 📞 CONTACT & APPLY (6)
    │   ├── contact_list_screen.dart
    │   ├── contact_detail_screen.dart
    │   ├── apply_connect_screen.dart
    │   ├── resume_match_preview_screen.dart
    │   ├── application_success_screen.dart
    │   └── saved_contacts_screen.dart
    │
    ├── 📂 USER DATA & HISTORY (6)
    │   ├── search_history_screen.dart
    │   ├── saved_searches_screen.dart
    │   ├── saved_places_screen.dart
    │   ├── resume_manager_screen.dart
    │   ├── edit_resume_screen.dart
    │   └── profile_analytics_screen.dart
    │
    ├── ⚙️ SETTINGS & INFO (5)
    │   ├── settings_screen.dart
    │   ├── theme_settings_screen.dart
    │   ├── notification_settings_screen.dart
    │   ├── help_support_screen.dart
    │   └── about_app_screen.dart
    │
    └── 🚨 EXTRA UX SCREENS (6)
        ├── permission_request_screen.dart
        ├── location_disabled_screen.dart
        ├── internet_error_screen.dart
        ├── maintenance_screen.dart
        ├── logout_confirmation_screen.dart
        └── account_delete_confirmation_screen.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Android Studio / VS Code
- Android SDK (API 21+)

### Setup

```bash
# Clone or extract the project
cd nearby_pro

# Get dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK
flutter build apk --release
```

---

## 🧭 Navigation Routes

All routes are defined in `main.dart`:

| Route | Screen |
|---|---|
| `/splash` | Splash Screen |
| `/onboarding1` | Onboarding 1 – Discover Places |
| `/onboarding2` | Onboarding 2 – Smart Search |
| `/onboarding3` | Onboarding 3 – Apply & Connect |
| `/login` | Login |
| `/signup` | Sign Up |
| `/create-profile` | Create Profile |
| `/personal-details` | Personal Details |
| `/education-details` | Education Details |
| `/skills-selection` | Skills Selection |
| `/resume-upload` | Resume Upload |
| `/profile-preview` | Profile Preview |
| `/home` | Home Dashboard |
| `/global-search` | Global Search |
| `/category-selection` | Category Selection |
| `/city-selection` | City Selection |
| `/area-selection` | Area Selection |
| `/distance-filter` | Distance Filter (10–100km) |
| `/advanced-filters` | Advanced Filters |
| `/search-loading` | Search Results Loading |
| `/results-list` | Results List View |
| `/results-map` | Results Map View |
| `/result-detail` | Single Result Detail |
| `/contact-info` | Contact Information |
| `/save-result` | Save Result |
| `/similar-places` | Similar Places |
| `/empty-results` | Empty Results |
| `/contact-list` | Contact List |
| `/contact-detail` | Contact Detail |
| `/apply-connect` | Apply / Connect |
| `/resume-match` | Resume Match Preview |
| `/application-success` | Application Success |
| `/saved-contacts` | Saved Contacts |
| `/search-history` | Search History |
| `/saved-searches` | Saved Searches |
| `/saved-places` | Saved Places |
| `/resume-manager` | Resume Manager |
| `/edit-resume` | Edit Resume |
| `/profile-analytics` | Profile Analytics |
| `/settings` | Settings |
| `/theme-settings` | Theme Settings |
| `/notification-settings` | Notification Settings |
| `/help-support` | Help & Support |
| `/about` | About App |
| `/permission` | Permission Request |
| `/location-disabled` | Location Disabled |
| `/internet-error` | Internet Error |
| `/maintenance` | Maintenance |
| `/logout-confirm` | Logout Confirmation |
| `/delete-account` | Account Delete Confirmation |

---

## 🔮 Next Steps (Post UI)

1. **Navigation**: Add `go_router` for deep linking
2. **State Management**: Integrate `riverpod` or `bloc`
3. **Google Maps API**: Add `google_maps_flutter` package
4. **Places API**: Connect `places_api` for real search
5. **Backend**: Firebase / Supabase / REST API
6. **Resume Parsing**: PDF extraction + AI matching

---

## ⚠️ Important Notes

- **UI Only** — No API, no logic, no state management
- All values are **placeholders / dummy data**
- Designed for **Android** (Flutter cross-platform ready)
- Theme colors follow **Material Design 3**
- All screens are **separate Dart files** in `lib/screens/`

---

*NearBy Pro © 2025 — UI Design v1.0.0*
