import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Skip', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_rounded, size: 100, color: AppColors.secondary),
              ),
              const SizedBox(height: 48),
              const Text(
                'Smart Search\nBy City & Distance',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textDark, height: 1.3),
              ),
              const SizedBox(height: 18),
              const Text(
                'Search by city, area, and set your preferred distance radius from 10km to 100km. Filter results your way.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _Dot(active: i == 1)),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/onboarding3'),
                child: const Text('Next'),
              ),
              const SizedBox(height: 32),
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
