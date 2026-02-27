import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SimilarPlacesScreen extends StatelessWidget {
  const SimilarPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = [
      {'name': 'NetSol Technologies', 'cat': 'Software House', 'dist': '4.2 km', 'rating': '4.4', 'openings': 8},
      {'name': 'Teradata Pakistan', 'cat': 'IT Company', 'dist': '6.7 km', 'rating': '4.6', 'openings': 3},
      {'name': 'Inbox Business Technologies', 'cat': 'Software House', 'dist': '9.1 km', 'rating': '4.3', 'openings': 12},
      {'name': 'i2c Inc. Pakistan', 'cat': 'FinTech', 'dist': '11.3 km', 'rating': '4.7', 'openings': 5},
      {'name': 'Tkxel', 'cat': 'Software House', 'dist': '13.0 km', 'rating': '4.2', 'openings': 7},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Similar Places')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.hub_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('Places similar to "Systems Ltd" within 25km', style: TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500))),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: places.length,
              itemBuilder: (context, i) {
                final p = places[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.computer_rounded, color: AppColors.primary, size: 24)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        const SizedBox(height: 3),
                        Text(p['cat'] as String, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 5),
                        Row(children: [
                          const Icon(Icons.location_on_rounded, size: 13, color: AppColors.textLight),
                          Text(p['dist'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFA726)),
                          Text(p['rating'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textGray, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text('${p['openings']} openings', style: const TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600))),
                        ]),
                      ])),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textLight)),
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
