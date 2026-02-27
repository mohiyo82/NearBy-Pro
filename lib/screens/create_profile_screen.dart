import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Profile'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepIndicator(current: 0, total: 5),
            const SizedBox(height: 32),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2.5),
                    ),
                    child: const Icon(Icons.person, size: 52, color: AppColors.textLight),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('Add Photo', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
            const SizedBox(height: 32),
            const Text('Tell us who you are', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('This helps us personalize your experience.', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
            const SizedBox(height: 24),
            const Text('Username', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'Choose a unique username', prefixIcon: Icon(Icons.alternate_email_rounded, color: AppColors.textGray))),
            const SizedBox(height: 20),
            const Text('Bio', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 3,
              maxLength: 150,
              decoration: InputDecoration(
                hintText: 'Tell employers a bit about yourself...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Profession / Role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const TextField(decoration: InputDecoration(hintText: 'e.g. Software Engineer, Student...', prefixIcon: Icon(Icons.work_outline_rounded, color: AppColors.textGray))),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/personal-details'),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text(
                  'I\'ll do this later',
                  style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step ${current + 1} of $total', style: const TextStyle(fontSize: 13, color: AppColors.textGray, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (current + 1) / total,
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
      ],
    );
  }
}
