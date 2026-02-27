import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    const Text('Welcome Back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    const Text('Sign in to your account', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.textGray),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textGray),
                  suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textGray),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or continue with', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.g_mobiledata, size: 28, color: AppColors.secondary),
                label: const Text('Continue with Google', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: AppColors.textGray),
                      children: [
                        TextSpan(text: 'Sign Up', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
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
