import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSent = false;

  void _sendResetLink() {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isSent = true);
    
    // Simulate sending email
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSent = false);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 24),
            const Text('Link Sent!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'A password reset link has been sent to\n${_emailController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGray, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Back to Login',
              onTap: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to Login Screen
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Forgot Password?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const Text(
                'Don\'t worry! It happens. Please enter the email address associated with your account.',
                style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
              ),
              const SizedBox(height: 40),
              const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.textGray),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Send Reset Link',
                isLoading: _isSent,
                onTap: _sendResetLink,
              ),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Remember password? ', style: TextStyle(color: AppColors.textGray)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Login', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
