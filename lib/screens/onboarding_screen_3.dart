import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Skip', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w500)),
                ),
              ]),
              const SizedBox(height: 32),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.10), shape: BoxShape.circle),
                child: const Icon(Icons.handshake_rounded, size: 100, color: AppColors.accent),
              ),
              const SizedBox(height: 48),
              const Text(
                'Apply & Connect\nWith Ease',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textDark, height: 1.3),
              ),
              const SizedBox(height: 18),
              const Text(
                'Create your profile, upload your resume, and connect with businesses and opportunities near you — all in one place.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _Dot(active: i == 2)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text(
                  'Already have an account? Log In',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({this.active = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
