import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Join NearBy Pro today', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
            const SizedBox(height: 32),
            _label('Full Name'),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'Enter your full name', prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textGray))),
            const SizedBox(height: 20),
            _label('Email Address'),
            const SizedBox(height: 8),
            const TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(hintText: 'Enter your email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.textGray))),
            const SizedBox(height: 20),
            _label('Phone Number'),
            const SizedBox(height: 8),
            const TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: '+92 --- -------', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textGray))),
            const SizedBox(height: 20),
            _label('Password'),
            const SizedBox(height: 8),
            const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Create a password', prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textGray), suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textGray))),
            const SizedBox(height: 20),
            _label('Confirm Password'),
            const SizedBox(height: 8),
            const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Confirm your password', prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textGray), suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textGray))),
            const SizedBox(height: 20),
            _label('I am a'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textGray),
              ),
              hint: const Text('Select user type'),
              items: const [
                DropdownMenuItem(value: 'student', child: Text('Student')),
                DropdownMenuItem(value: 'job_seeker', child: Text('Job Seeker')),
                DropdownMenuItem(value: 'business', child: Text('Business Explorer')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}, activeColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I agree to the ',
                      style: const TextStyle(color: AppColors.textGray, fontSize: 13),
                      children: [
                        TextSpan(text: 'Terms of Service', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        const TextSpan(text: ' and '),
                        TextSpan(text: 'Privacy Policy', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/create-profile'),
              child: const Text('Create Account'),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text.rich(TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: AppColors.textGray),
                  children: [TextSpan(text: 'Sign In', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))],
                )),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark));
}
