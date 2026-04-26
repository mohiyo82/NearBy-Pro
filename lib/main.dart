import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

// ─── AUTH & ONBOARDING ──────────────────────────────────
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/logout_confirmation_screen.dart';
import 'screens/onboarding/onboarding_screen_1.dart';
import 'screens/onboarding/onboarding_screen_2.dart';
import 'screens/onboarding/onboarding_screen_3.dart';

// ─── PROFILE SETUP & USER PROFILE ───────────────────────
import 'screens/profile/create_profile_screen.dart';
import 'screens/profile/personal_details_screen.dart';
import 'screens/profile/education_details_screen.dart';
import 'screens/profile/skills_selection_screen.dart';
import 'screens/profile/resume_upload_screen.dart';
import 'screens/profile/profile_preview_screen.dart';
import 'screens/profile/resume_manager_screen.dart';
import 'screens/profile/edit_resume_screen.dart';
import 'screens/profile/edit_profile_screen.dart'; // Import Fix
import 'screens/profile/profile_analytics_screen.dart';

// ─── MAIN APP FLOW ──────────────────────────────────────
import 'screens/home/main_wrapper.dart'; 
import 'screens/home/home_dashboard_screen.dart';
import 'screens/search/global_search_screen.dart';
import 'screens/search/category_selection_screen.dart';
import 'screens/search/city_selection_screen.dart';
import 'screens/search/area_selection_screen.dart';
import 'screens/search/distance_filter_screen.dart';
import 'screens/search/advanced_filters_screen.dart';
import 'screens/search/map_location_picker_screen.dart';
import 'screens/search/search_history_screen.dart';
import 'screens/search/saved_searches_screen.dart';

// ─── RESULTS & ACTIONS ──────────────────────────────────
import 'screens/results/results_list_view_screen.dart';
import 'screens/results/results_map_view_screen.dart';
import 'screens/results/single_result_card_detail_screen.dart';
import 'screens/results/search_results_loading_screen.dart';
import 'screens/results/save_result_screen.dart';
import 'screens/results/similar_places_screen.dart';
import 'screens/results/empty_result_screen.dart';
import 'screens/results/contact_information_screen.dart';
import 'screens/results/contact_list_screen.dart';
import 'screens/results/contact_detail_screen.dart';
import 'screens/results/apply_connect_screen.dart';
import 'screens/results/resume_match_preview_screen.dart';
import 'screens/results/application_success_screen.dart';
import 'screens/results/saved_contacts_screen.dart';
import 'screens/results/saved_places_screen.dart';

// ─── SETTINGS & INFO ────────────────────────────────────
import 'screens/settings/settings_screen.dart';
import 'screens/settings/theme_settings_screen.dart';
import 'screens/settings/notification_settings_screen.dart';
import 'screens/settings/help_support_screen.dart';
import 'screens/settings/about_app_screen.dart';
import 'screens/settings/security_settings_screen.dart';
import 'screens/settings/privacy_settings_screen.dart';
import 'screens/settings/subscription_plans_screen.dart';
import 'screens/settings/payment_method_screen.dart';
import 'screens/auth/account_delete_confirmation_screen.dart';

// ─── SYSTEM & UX ────────────────────────────────────────
import 'screens/system/permission_request_screen.dart';
import 'screens/system/location_disabled_screen.dart';
import 'screens/system/internet_error_screen.dart';
import 'screens/system/maintenance_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text('Oops! Something went wrong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('We have logged this issue and our team is looking into it.', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () {}, child: const Text('Refresh App')),
              ],
            ),
          ),
        ),
      ),
    );
  };

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
      ],
      child: const NearByProApp(),
    ),
  );
}

class NearByProApp extends StatelessWidget {
  const NearByProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NearBy Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding1': (_) => const OnboardingScreen1(),
        '/onboarding2': (_) => const OnboardingScreen2(),
        '/onboarding3': (_) => const OnboardingScreen3(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/create-profile': (_) => const CreateProfileScreen(),
        '/personal-details': (_) => const PersonalDetailsScreen(),
        '/education-details': (_) => const EducationDetailsScreen(),
        '/skills-selection': (_) => const SkillsSelectionScreen(),
        '/resume-upload': (_) => const ResumeUploadScreen(),
        '/profile-preview': (_) => const ProfilePreviewScreen(),
        '/edit-profile': (_) => const EditProfileScreen(), // Route Added
        '/home': (_) => const MainWrapper(), 
        '/global-search': (_) => const GlobalSearchScreen(),
        '/category-selection': (_) => const CategorySelectionScreen(),
        '/city-selection': (_) => const CitySelectionScreen(),
        '/area-selection': (_) => const AreaSelectionScreen(),
        '/distance-filter': (_) => const DistanceFilterScreen(),
        '/advanced-filters': (_) => const AdvancedFiltersScreen(),
        '/search-loading': (_) => const SearchResultsLoadingScreen(),
        '/map-picker': (_) => const MapLocationPickerScreen(),
        '/results-list': (_) => const ResultsListViewScreen(),
        '/results-map': (_) => const ResultsMapViewScreen(),
        '/result-detail': (_) => const SingleResultCardDetailScreen(),
        '/contact-info': (_) => const ContactInformationScreen(),
        '/save-result': (_) => const SaveResultScreen(),
        '/similar-places': (_) => const SimilarPlacesScreen(),
        '/empty-results': (_) => const EmptyResultScreen(),
        '/contact-list': (_) => const ContactListScreen(),
        '/contact-detail': (_) => const ContactDetailScreen(),
        '/apply-connect': (_) => const ApplyConnectScreen(),
        '/resume-match': (_) => const ResumeMatchPreviewScreen(),
        '/application-success': (_) => const ApplicationSuccessScreen(),
        '/saved-contacts': (_) => const SavedContactsScreen(),
        '/search-history': (_) => const SearchHistoryScreen(),
        '/saved-searches': (_) => const SavedSearchesScreen(),
        '/saved-places': (_) => const SavedPlacesScreen(),
        '/resume-manager': (_) => const ResumeManagerScreen(),
        '/edit-resume': (_) => const EditResumeScreen(),
        '/profile-analytics': (_) => const ProfileAnalyticsScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/theme-settings': (_) => const ThemeSettingsScreen(),
        '/notification-settings': (_) => const NotificationSettingsScreen(),
        '/help-support': (_) => const HelpSupportScreen(),
        '/about': (_) => const AboutAppScreen(),
        '/security-settings': (_) => const SecuritySettingsScreen(),
        '/privacy-settings': (_) => const PrivacySettingsScreen(),
        '/subscriptions': (_) => const SubscriptionPlansScreen(),
        '/payment-method': (_) => const PaymentMethodScreen(),
        '/permission': (_) => const PermissionRequestScreen(),
        '/location-disabled': (_) => const LocationDisabledScreen(),
        '/internet-error': (_) => const InternetErrorScreen(),
        '/maintenance': (_) => const MaintenanceScreen(),
        '/logout-confirm': (_) => const LogoutConfirmationScreen(),
        '/delete-account': (_) => const AccountDeleteConfirmationScreen(),
      },
    );
  }
}
