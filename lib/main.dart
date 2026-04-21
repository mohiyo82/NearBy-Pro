import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen_1.dart';
import 'screens/onboarding_screen_2.dart';
import 'screens/onboarding_screen_3.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/create_profile_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/education_details_screen.dart';
import 'screens/skills_selection_screen.dart';
import 'screens/resume_upload_screen.dart';
import 'screens/profile_preview_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/global_search_screen.dart';
import 'screens/category_selection_screen.dart';
import 'screens/city_selection_screen.dart';
import 'screens/area_selection_screen.dart';
import 'screens/distance_filter_screen.dart';
import 'screens/advanced_filters_screen.dart';
import 'screens/search_results_loading_screen.dart';
import 'screens/map_location_picker_screen.dart';
import 'screens/results_list_view_screen.dart';
import 'screens/results_map_view_screen.dart';
import 'screens/single_result_card_detail_screen.dart';
import 'screens/contact_information_screen.dart';
import 'screens/save_result_screen.dart';
import 'screens/similar_places_screen.dart';
import 'screens/empty_result_screen.dart';
import 'screens/contact_list_screen.dart';
import 'screens/contact_detail_screen.dart';
import 'screens/apply_connect_screen.dart';
import 'screens/resume_match_preview_screen.dart';
import 'screens/application_success_screen.dart';
import 'screens/saved_contacts_screen.dart';
import 'screens/search_history_screen.dart';
import 'screens/saved_searches_screen.dart';
import 'screens/saved_places_screen.dart';
import 'screens/resume_manager_screen.dart';
import 'screens/edit_resume_screen.dart';
import 'screens/profile_analytics_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/theme_settings_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/about_app_screen.dart';
import 'screens/security_settings_screen.dart';
import 'screens/privacy_settings_screen.dart';
import 'screens/subscription_plans_screen.dart';
import 'screens/payment_method_screen.dart';
import 'screens/permission_request_screen.dart';
import 'screens/location_disabled_screen.dart';
import 'screens/internet_error_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/logout_confirmation_screen.dart';
import 'screens/account_delete_confirmation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    
    // Crashlytics Setup
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

  // Graceful Error Handling (Checklist Point #4)
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
    // Architecture & State Integrity (Checklist Point #1)
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
        '/home': (_) => const HomeDashboardScreen(),
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
