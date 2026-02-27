import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactInformationScreen extends StatelessWidget {
  const ContactInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contact Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.business_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Company Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('Software House • Lahore', style: TextStyle(fontSize: 13, color: Colors.white70)),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('Contact Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            _ContactTile(icon: Icons.phone_rounded, label: 'Primary Phone', value: '+92 --- -------', color: AppColors.primary, action: 'Call'),
            _ContactTile(icon: Icons.phone_outlined, label: 'Secondary Phone', value: 'Not Listed', color: AppColors.textLight, action: null),
            _ContactTile(icon: Icons.email_rounded, label: 'Email Address', value: 'hr@company.com', color: AppColors.secondary, action: 'Email'),
            _ContactTile(icon: Icons.language_rounded, label: 'Website', value: 'www.company.com', color: AppColors.accent, action: 'Visit'),
            _ContactTile(icon: Icons.location_on_rounded, label: 'Full Address', value: 'Building #, Street, Area,\nLahore, Punjab, Pakistan', color: AppColors.error, action: 'Map'),
            const SizedBox(height: 24),
            const Text('Social Media', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Row(children: [
              _SocialBtn(icon: Icons.link, label: 'LinkedIn', color: const Color(0xFF0077B5)),
              const SizedBox(width: 10),
              _SocialBtn(icon: Icons.code, label: 'GitHub', color: const Color(0xFF333333)),
              const SizedBox(width: 10),
              _SocialBtn(icon: Icons.facebook, label: 'Facebook', color: const Color(0xFF1877F2)),
            ]),
            const SizedBox(height: 24),
            const Text('Working Hours', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            ...['Monday – Friday', 'Saturday', 'Sunday'].asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Text(e.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                const Spacer(),
                Text(e.key == 0 ? '9:00 AM – 6:00 PM' : e.key == 1 ? '10:00 AM – 2:00 PM' : 'Closed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: e.key == 2 ? AppColors.error : AppColors.primary)),
              ]),
            )),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send_rounded),
              label: const Text('Apply / Connect Now'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.bookmark_outline_rounded, color: AppColors.primary),
              label: const Text('Save Contact', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final String? action;
  const _ContactTile({required this.icon, required this.label, required this.value, required this.color, this.action});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ])),
        if (action != null)
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(action!, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w700)),
            ),
          ),
      ]),
    ),
  );
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SocialBtn({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ]),
      ),
    ),
  );
}
