import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGray),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'HR Departments', 'Companies', 'Recruiters', 'Saved'].map((f) {
                  final s = f == 'All';
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: s ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: s ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: s ? Colors.white : AppColors.textDark)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.business_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Company Contact ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        const Text('HR Department • Software House', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                        const SizedBox(height: 4),
                        const Text('+92 --- -------', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ])),
                      Column(children: [
                        GestureDetector(onTap: () {}, child: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 22)),
                        const SizedBox(height: 10),
                        GestureDetector(onTap: () {}, child: const Icon(Icons.email_outlined, color: AppColors.secondary, size: 22)),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
