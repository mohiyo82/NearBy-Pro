import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyResultScreen extends StatelessWidget {
  const EmptyResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Search Results')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                child: const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight),
              ),
              const SizedBox(height: 28),
              const Text('No Results Found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const Text(
                'We couldn\'t find any places matching your search criteria. Try adjusting your filters or expanding the search radius.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.6),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Try these suggestions:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    SizedBox(height: 10),
                    _Tip(icon: Icons.tune_rounded, text: 'Adjust or reset your filters'),
                    _Tip(icon: Icons.radar_rounded, text: 'Increase the distance radius'),
                    _Tip(icon: Icons.location_city_rounded, text: 'Try a different city or area'),
                    _Tip(icon: Icons.search_rounded, text: 'Use different search keywords'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Modify Search'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text('Go Back to Home', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Tip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, size: 16, color: AppColors.primary),
      const SizedBox(width: 10),
      Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
    ]),
  );
}
