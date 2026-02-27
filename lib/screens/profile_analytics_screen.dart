import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileAnalyticsScreen extends StatelessWidget {
  const ProfileAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Profile Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(child: _StatCard2(title: 'Profile Views', value: '0', icon: Icons.visibility_rounded, color: AppColors.primary, change: '0%')),
              const SizedBox(width: 12),
              Expanded(child: _StatCard2(title: 'Applications', value: '0', icon: Icons.send_rounded, color: AppColors.secondary, change: '0%')),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _StatCard2(title: 'Saved Places', value: '0', icon: Icons.bookmark_rounded, color: AppColors.accent, change: '0%')),
              const SizedBox(width: 12),
              Expanded(child: _StatCard2(title: 'Searches Done', value: '0', icon: Icons.search_rounded, color: const Color(0xFF7E57C2), change: '0%')),
            ]),
            const SizedBox(height: 24),
            const Text('Profile Strength', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                children: [
                  Row(children: [
                    const Text('Overall Score', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const Spacer(),
                    const Text('0 / 100', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 18)),
                  ]),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(value: 0, backgroundColor: AppColors.border, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary), minHeight: 8),
                  const SizedBox(height: 16),
                  ...[
                    _StrengthRow('Profile Photo', false),
                    _StrengthRow('Bio', false),
                    _StrengthRow('Education', false),
                    _StrengthRow('Skills (5+)', false),
                    _StrengthRow('Resume Uploaded', false),
                    _StrengthRow('Work Experience', false),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Activity This Week', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No activity yet', style: TextStyle(color: AppColors.textGray, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(7, (i) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(color: AppColors.border.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                          ),
                          const SizedBox(height: 4),
                          Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][i], style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                        ]),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatCard2 extends StatelessWidget {
  final String title, value, change;
  final IconData icon;
  final Color color;
  const _StatCard2({required this.title, required this.value, required this.icon, required this.color, required this.change});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 24),
      const SizedBox(height: 8),
      Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
      Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
    ]),
  );
}

class _StrengthRow extends StatelessWidget {
  final String label;
  final bool done;
  const _StrengthRow(this.label, this.done);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: done ? AppColors.success : AppColors.border, size: 18),
      const SizedBox(width: 10),
      Text(label, style: TextStyle(fontSize: 13, color: done ? AppColors.textDark : AppColors.textGray, fontWeight: done ? FontWeight.w600 : FontWeight.w400)),
      if (!done) ...[const Spacer(), TextButton(onPressed: () {}, child: const Text('Add', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)))],
    ]),
  );
}
