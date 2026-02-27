import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ApplyConnectScreen extends StatelessWidget {
  const ApplyConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Apply / Connect')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]), borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const Icon(Icons.business_rounded, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Company Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('Software House • Lahore', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ])),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('Application Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),
            const Text('Position Applying For', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), prefixIcon: const Icon(Icons.work_outline_rounded, color: AppColors.textGray)),
              hint: const Text('Select position'),
              items: const [
                DropdownMenuItem(value: 'flutter', child: Text('Flutter Developer')),
                DropdownMenuItem(value: 'python', child: Text('Python Developer')),
                DropdownMenuItem(value: 'uiux', child: Text('UI/UX Designer')),
                DropdownMenuItem(value: 'general', child: Text('General Application')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),
            const Text('Cover Letter / Message', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 6,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Write a brief message to the employer...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Attach Resume', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
                child: Row(children: [
                  const Icon(Icons.attach_file_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('No resume selected (tap to attach)', style: TextStyle(color: AppColors.textGray))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Browse', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Contact Preference', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 10),
            ...['Email', 'Phone Call', 'WhatsApp', 'Walk-in'].map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                Checkbox(value: c == 'Email', onChanged: (_) {}, activeColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                Text(c, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
              ]),
            )),
            const SizedBox(height: 32),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.send_rounded), label: const Text('Submit Application')),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
