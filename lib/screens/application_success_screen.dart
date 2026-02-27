import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ApplicationSuccessScreen extends StatelessWidget {
  const ApplicationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: AppColors.success, width: 3)),
                child: const Icon(Icons.check_rounded, size: 72, color: AppColors.success),
              ),
              const SizedBox(height: 32),
              const Text('Application Sent!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const Text(
                'Your application has been successfully submitted to Company Name. You will be notified when they respond.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: Column(
                  children: [
                    const Text('Application Reference', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                    const SizedBox(height: 4),
                    const Text('#APP-00000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1)),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    _Detail(label: 'Company', value: 'Company Name'),
                    _Detail(label: 'Position', value: 'Flutter Developer'),
                    _Detail(label: 'Date', value: 'Today'),
                    _Detail(label: 'Status', value: 'Submitted'),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text('Track My Application')),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52), side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Back to Search', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: () {}, child: const Text('Find More Opportunities', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final String label, value;
  const _Detail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
      const Spacer(),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
    ]),
  );
}
