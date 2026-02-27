import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';

// Auth & Onboarding
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen_1.dart';
import 'screens/onboarding_screen_2.dart';
import 'screens/onboarding_screen_3.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';

// Profile Setup
import 'screens/create_profile_screen.dart';
import 'screens/personal_details_screen.dart';
import 'screens/education_details_screen.dart';
import 'screens/skills_selection_screen.dart';
import 'screens/resume_upload_screen.dart';
import 'screens/profile_preview_screen.dart';

// Main App Flow
import 'screens/home_dashboard_screen.dart';
import 'screens/global_search_screen.dart';
import 'screens/category_selection_screen.dart';
import 'screens/city_selection_screen.dart';
import 'screens/area_selection_screen.dart';
import 'screens/distance_filter_screen.dart';
import 'screens/advanced_filters_screen.dart';
import 'screens/search_results_loading_screen.dart';
import 'screens/map_location_picker_screen.dart';

// Search Results
import 'screens/results_list_view_screen.dart';
import 'screens/results_map_view_screen.dart';
import 'screens/single_result_card_detail_screen.dart';
import 'screens/contact_information_screen.dart';
import 'screens/save_result_screen.dart';
import 'screens/similar_places_screen.dart';
import 'screens/empty_result_screen.dart';

// Contact & Apply
import 'screens/contact_list_screen.dart';
import 'screens/contact_detail_screen.dart';
import 'screens/apply_connect_screen.dart';
import 'screens/resume_match_preview_screen.dart';
import 'screens/application_success_screen.dart';
import 'screens/saved_contacts_screen.dart';

// User Data & History
import 'screens/search_history_screen.dart';
import 'screens/saved_searches_screen.dart';
import 'screens/saved_places_screen.dart';
import 'screens/resume_manager_screen.dart';
import 'screens/edit_resume_screen.dart';
import 'screens/profile_analytics_screen.dart';

// Settings & Info
import 'screens/settings_screen.dart';
import 'screens/theme_settings_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/about_app_screen.dart';
import 'screens/security_settings_screen.dart';
import 'screens/privacy_settings_screen.dart';
import 'screens/subscription_plans_screen.dart';
import 'screens/payment_method_screen.dart';

// Extra UX Screens
import 'screens/permission_request_screen.dart';
import 'screens/location_disabled_screen.dart';
import 'screens/internet_error_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/logout_confirmation_screen.dart';
import 'screens/account_delete_confirmation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const NearByProApp());
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
        // ── Auth & Onboarding ──────────────────────────────────
        '/splash': (_) => const SplashScreen(),
        '/onboarding1': (_) => const OnboardingScreen1(),
        '/onboarding2': (_) => const OnboardingScreen2(),
        '/onboarding3': (_) => const OnboardingScreen3(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),

        // ── Profile Setup ──────────────────────────────────────
        '/create-profile': (_) => const CreateProfileScreen(),
        '/personal-details': (_) => const PersonalDetailsScreen(),
        '/education-details': (_) => const EducationDetailsScreen(),
        '/skills-selection': (_) => const SkillsSelectionScreen(),
        '/resume-upload': (_) => const ResumeUploadScreen(),
        '/profile-preview': (_) => const ProfilePreviewScreen(),

        // ── Main App Flow ──────────────────────────────────────
        '/home': (_) => const HomeDashboardScreen(),
        '/global-search': (_) => const GlobalSearchScreen(),
        '/category-selection': (_) => const CategorySelectionScreen(),
        '/city-selection': (_) => const CitySelectionScreen(),
        '/area-selection': (_) => const AreaSelectionScreen(),
        '/distance-filter': (_) => const DistanceFilterScreen(),
        '/advanced-filters': (_) => const AdvancedFiltersScreen(),
        '/search-loading': (_) => const SearchResultsLoadingScreen(),
        '/map-picker': (_) => const MapLocationPickerScreen(),

        // ── Search Results ─────────────────────────────────────
        '/results-list': (_) => const ResultsListViewScreen(),
        '/results-map': (_) => const ResultsMapViewScreen(),
        '/result-detail': (_) => const Single_result_card_detail_screen_detail_screen(),
        '/contact-info': (_) => const ContactInformationScreen(),
        '/save-result': (_) => const SaveResultScreen(),
        '/similar-places': (_) => const SimilarPlacesScreen(),
        '/empty-results': (_) => const EmptyResultScreen(),

        // ── Contact & Apply ────────────────────────────────────
        '/contact-list': (_) => const ContactListScreen(),
        '/contact-detail': (_) => const ContactDetailScreen(),
        '/apply-connect': (_) => const ApplyConnectScreen(),
        '/resume-match': (_) => const ResumeMatchPreviewScreen(),
        '/application-success': (_) => const ApplicationSuccessScreen(),
        '/saved-contacts': (_) => const SavedContactsScreen(),

        // ── User Data & History ────────────────────────────────
        '/search-history': (_) => const SearchHistoryScreen(),
        '/saved-searches': (_) => const SavedSearchesScreen(),
        '/saved-places': (_) => const SavedPlacesScreen(),
        '/resume-manager': (_) => const ResumeManagerScreen(),
        '/edit-resume': (_) => const EditResumeScreen(),
        '/profile-analytics': (_) => const ProfileAnalyticsScreen(),

        // ── Settings & Info ────────────────────────────────────
        '/settings': (_) => const SettingsScreen(),
        '/theme-settings': (_) => const ThemeSettingsScreen(),
        '/notification-settings': (_) => const NotificationSettingsScreen(),
        '/help-support': (_) => const HelpSupportScreen(),
        '/about': (_) => const AboutAppScreen(),
        '/security-settings': (_) => const SecuritySettingsScreen(),
        '/privacy-settings': (_) => const PrivacySettingsScreen(),
        '/subscriptions': (_) => const SubscriptionPlansScreen(),
        '/payment-method': (_) => const PaymentMethodScreen(),

        // ── Extra UX ───────────────────────────────────────────
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

class Single_result_card_detail_screen_detail_screen extends StatelessWidget {
  const Single_result_card_detail_screen_detail_screen({super.key});
  @override
  Widget build(BuildContext context) => const SingleResultCardDetailScreen();
}
