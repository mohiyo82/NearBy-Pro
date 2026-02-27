import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SavedContactsScreen extends StatelessWidget {
  const SavedContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Systems Ltd', 'role': 'Software House', 'phone': '+92-42-111-111-000', 'city': 'Lahore', 'icon': Icons.computer_rounded},
      {'name': 'Shaukat Khanum Hospital', 'role': 'Healthcare', 'phone': '+92-42-35941234', 'city': 'Lahore', 'icon': Icons.local_hospital_rounded},
      {'name': 'COMSATS University', 'role': 'Education', 'phone': '+92-51-9247000', 'city': 'Islamabad', 'icon': Icons.school_rounded},
      {'name': 'Habib Bank Limited', 'role': 'Banking', 'phone': '+92-21-111-425-888', 'city': 'Karachi', 'icon': Icons.account_balance_rounded},
      {'name': 'Packages Ltd', 'role': 'Industrial', 'phone': '+92-42-5211701', 'city': 'Lahore', 'icon': Icons.factory_rounded},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Saved Contacts'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.sort_rounded)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatBox(label: 'Total', value: '${contacts.length}', icon: Icons.contacts_rounded),
                const SizedBox(width: 12),
                const _StatBox(label: 'Applied', value: '2', icon: Icons.send_rounded),
                const SizedBox(width: 12),
                const _StatBox(label: 'This Week', value: '3', icon: Icons.calendar_today_rounded),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: contacts.length,
              itemBuilder: (context, i) {
                final c = contacts[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(c['icon'] as IconData, color: AppColors.primary, size: 24)),
                    title: Text(c['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 3),
                      Text(c['role'] as String, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Row(children: [
                        const Icon(Icons.phone_rounded, size: 12, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(c['phone'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                      ]),
                    ]),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.call_rounded, color: AppColors.primary, size: 20)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatBox({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
        ]),
      ),
    );
  }
}
