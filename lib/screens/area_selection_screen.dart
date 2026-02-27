import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AreaSelectionScreen extends StatelessWidget {
  const AreaSelectionScreen({super.key});

  static const List<String> _areas = ['Gulberg', 'DHA Phase 1-9', 'Model Town', 'Johar Town', 'Bahria Town', 'Township', 'Cantt', 'Iqbal Town', 'Garden Town', 'Wapda Town', 'Muslim Town', 'Shadman', 'Faisal Town', 'Valencia', 'Raiwind Road', 'Barki Road', 'Thokar Niaz Baig'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Area'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search area, sector, town...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGray),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.primary.withOpacity(0.06),
            child: Row(children: [
              const Icon(Icons.location_city_rounded, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text('Lahore', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 15)),
              const SizedBox(width: 4),
              const Text('— Selected City', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Change', style: TextStyle(color: AppColors.primary, fontSize: 13))),
            ]),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _areas.length + 1,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                if (i == 0) return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    const Icon(Icons.near_me_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Text('Search all areas in Lahore', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ]),
                );
                final area = _areas[i - 1];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.location_on_outlined, color: AppColors.textGray, size: 18),
                  ),
                  title: Text(area, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  subtitle: const Text('Lahore, Punjab', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
