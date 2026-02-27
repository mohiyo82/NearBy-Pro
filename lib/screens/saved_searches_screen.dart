import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SavedSearchesScreen extends StatelessWidget {
  const SavedSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = [
      {'name': 'Tech Jobs Lahore', 'filter': '25km • IT Companies', 'icon': Icons.computer_rounded, 'count': 34, 'notify': true},
      {'name': 'Hospitals Near Home', 'filter': '10km • Healthcare', 'icon': Icons.local_hospital_rounded, 'count': 8, 'notify': false},
      {'name': 'Schools in Gulberg', 'filter': '15km • Education', 'icon': Icons.school_rounded, 'count': 21, 'notify': true},
      {'name': 'Banks Faisalabad', 'filter': '20km • Finance', 'icon': Icons.account_balance_rounded, 'count': 11, 'notify': false},
      {'name': 'Factories Industrial Area', 'filter': '50km • Industrial', 'icon': Icons.factory_rounded, 'count': 6, 'notify': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Saved Searches'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline_rounded))],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Save Current Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.bookmark_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('5 Saved Searches', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Enable alerts for instant notifications', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: saved.length,
              itemBuilder: (context, index) {
                final s = saved[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(s['icon'] as IconData, color: AppColors.primary, size: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(s['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          const SizedBox(height: 3),
                          Text(s['filter'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                          const SizedBox(height: 6),
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Text('${s['count']} results', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ),
                            if (s['notify'] as bool) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.notifications_active_rounded, size: 14, color: Color(0xFFFFA726)),
                              const SizedBox(width: 2),
                              const Text('Alert on', style: TextStyle(fontSize: 11, color: Color(0xFFFFA726), fontWeight: FontWeight.w500)),
                            ],
                          ]),
                        ]),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded, color: AppColors.primary)),
                    ],
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
