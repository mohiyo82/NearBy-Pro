import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResumeMatchPreviewScreen extends StatelessWidget {
  const ResumeMatchPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Resume Match Preview')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.1), AppColors.secondary.withOpacity(0.1)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('Match Score', style: TextStyle(fontSize: 14, color: AppColors.textGray, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: 0,
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          strokeWidth: 8,
                        ),
                      ),
                      const Column(children: [
                        Text('0%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        Text('Match', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Complete your profile to improve match score', style: TextStyle(fontSize: 13, color: AppColors.textGray), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Skills Comparison', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            _MatchSection(
              title: 'Matching Skills',
              items: const [],
              color: AppColors.success,
              icon: Icons.check_circle_rounded,
              emptyText: 'No matching skills found',
            ),
            const SizedBox(height: 12),
            _MatchSection(
              title: 'Missing Skills',
              items: const ['Flutter', 'Dart', 'Firebase'],
              color: AppColors.error,
              icon: Icons.cancel_rounded,
              emptyText: '',
            ),
            const SizedBox(height: 24),
            const Text('Qualification Check', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            _QualRow(label: 'Education Level', required: 'Bachelor\'s Degree', yours: 'Not Set', match: false),
            _QualRow(label: 'Experience', required: '1–3 Years', yours: '0 Years', match: false),
            _QualRow(label: 'Location Match', required: 'Lahore', yours: 'Your City', match: false),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text('Proceed to Apply')),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52), side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Update My Profile First', style: TextStyle(color: AppColors.primary)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MatchSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color color;
  final IconData icon;
  final String emptyText;
  const _MatchSection({required this.title, required this.items, required this.color, required this.icon, required this.emptyText});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: color.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        ]),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Text(emptyText.isNotEmpty ? emptyText : 'None found', style: const TextStyle(fontSize: 13, color: AppColors.textGray))
        else
          Wrap(spacing: 8, runSpacing: 8, children: items.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(s, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
          )).toList()),
      ],
    ),
  );
}

class _QualRow extends StatelessWidget {
  final String label, required, yours;
  final bool match;
  const _QualRow({required this.label, required this.required, required this.yours, required this.match});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(match ? Icons.check_circle_rounded : Icons.cancel_rounded, color: match ? AppColors.success : AppColors.error, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          Text('Required: $required', style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
          Text('Yours: $yours', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
        ])),
      ]),
    ),
  );
}
