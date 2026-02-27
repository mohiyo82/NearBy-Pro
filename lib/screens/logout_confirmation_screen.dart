import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LogoutConfirmationScreen extends StatelessWidget {
  const LogoutConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 50),
              ),
              const SizedBox(height: 28),
              const Text('Log Out?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const Text(
                'You will be signed out of your NearBy Pro account. Your saved places, searches, and profile data will remain intact.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                child: Column(children: const [
                  Row(children: [
                    Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text('Your profile stays saved', style: TextStyle(fontSize: 13, color: AppColors.textDark))),
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text('Bookmarks and history preserved', style: TextStyle(fontSize: 13, color: AppColors.textDark))),
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text('Resume and documents safe', style: TextStyle(fontSize: 13, color: AppColors.textDark))),
                  ]),
                ]),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Login and clear all previous routes
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Yes, Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
