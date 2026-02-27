import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contact Detail'), actions: [
        IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.person, size: 48, color: AppColors.primary),
                  ),
                  const SizedBox(height: 14),
                  const Text('HR Manager', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  const Text('Company Name • Lahore', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionBtn(icon: Icons.phone_rounded, label: 'Call', color: AppColors.primary),
                      const SizedBox(width: 16),
                      _ActionBtn(icon: Icons.email_rounded, label: 'Email', color: AppColors.secondary),
                      const SizedBox(width: 16),
                      _ActionBtn(icon: Icons.send_rounded, label: 'Apply', color: AppColors.accent),
                      const SizedBox(width: 16),
                      _ActionBtn(icon: Icons.bookmark_rounded, label: 'Save', color: AppColors.warning),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _SectionCard(title: 'Contact Info', children: [
              _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: '+92 --- -------'),
              _InfoRow(icon: Icons.email_outlined, label: 'Email', value: 'hr@company.com'),
              _InfoRow(icon: Icons.language_rounded, label: 'Website', value: 'www.company.com'),
            ]),
            const SizedBox(height: 16),
            _SectionCard(title: 'Work Details', children: [
              _InfoRow(icon: Icons.business_rounded, label: 'Company', value: 'Company Name'),
              _InfoRow(icon: Icons.work_outline_rounded, label: 'Department', value: 'Human Resources'),
              _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: 'Gulberg, Lahore'),
            ]),
            const SizedBox(height: 16),
            _SectionCard(title: 'Notes', children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add personal notes about this contact...',
                    hintStyle: const TextStyle(fontSize: 13),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () {}, child: const Text('Send Application')),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionBtn({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {},
    child: Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const Divider(height: 16),
        ...children,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.primary),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      ]),
      const Spacer(),
      const Icon(Icons.copy_rounded, size: 16, color: AppColors.textLight),
    ]),
  );
}
