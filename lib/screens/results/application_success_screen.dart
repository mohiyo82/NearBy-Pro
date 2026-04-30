import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ApplicationSuccessScreen extends StatelessWidget {
  const ApplicationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receiving arguments from ApplyConnectScreen
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {
      'companyName': 'the Company',
      'position': 'Job Position',
    };

    final String companyName = args['companyName'];
    final String position = args['position'];
    final String refNo = '#APP-${Random().nextInt(90000) + 10000}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Success Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                  child: const Icon(Icons.check_circle_rounded, size: 80, color: AppColors.success),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Application Sent!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your application has been successfully submitted to $companyName. You will be notified when they respond.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.6),
                ),
                const SizedBox(height: 40),
                
                // Application Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      const Text('Application Reference', style: TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Text(refNo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1)),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 20),
                      _DetailRow(label: 'Company', value: companyName),
                      _DetailRow(label: 'Position', value: position),
                      _DetailRow(label: 'Date', value: 'Just Now'),
                      _DetailRow(label: 'Status', value: 'Submitted', isStatus: true),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60), // Extra space for better scrolling
                
                // Action Buttons
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/contact-list'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Track My Applications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Back to Home', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Find More Opportunities', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  final bool isStatus;
  const _DetailRow({required this.label, required this.value, this.isStatus = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
        const Spacer(),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
          )
        else
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      ],
    ),
  );
}
