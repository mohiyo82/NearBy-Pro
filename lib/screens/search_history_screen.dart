import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchHistoryScreen extends StatelessWidget {
  const SearchHistoryScreen({super.key});

  static const List<Map<String, dynamic>> _history = [
    {'query': 'Software Houses in Lahore', 'category': 'Tech', 'date': 'Today, 10:22 AM', 'icon': Icons.computer_rounded, 'count': 12},
    {'query': 'Hospitals near me', 'category': 'Healthcare', 'date': 'Today, 09:05 AM', 'icon': Icons.local_hospital_rounded, 'count': 8},
    {'query': 'Private Schools Johar Town', 'category': 'Education', 'date': 'Yesterday, 04:30 PM', 'icon': Icons.school_rounded, 'count': 15},
    {'query': 'Banks within 5km', 'category': 'Finance', 'date': 'Yesterday, 01:10 PM', 'icon': Icons.account_balance_rounded, 'count': 6},
    {'query': 'IT Companies Karachi', 'category': 'Tech', 'date': '2 days ago', 'icon': Icons.business_rounded, 'count': 22},
    {'query': 'Restaurants near office', 'category': 'Food', 'date': '3 days ago', 'icon': Icons.restaurant_rounded, 'count': 18},
    {'query': 'Factories Faisalabad', 'category': 'Industrial', 'date': '1 week ago', 'icon': Icons.factory_rounded, 'count': 7},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Search History'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Clear All',
                style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search in history
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in history...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Stats bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('7 searches this week',
                      style: TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('7',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item['icon'] as IconData,
                          color: AppColors.primary, size: 22),
                    ),
                    title: Text(
                      item['query'] as String,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(item['category'] as String,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Text(item['date'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${item['count']}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark)),
                            const Text('results',
                                style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                          ],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close_rounded,
                              size: 18, color: AppColors.textLight),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    onTap: () {},
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
