import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DistanceFilterScreen extends StatelessWidget {
  const DistanceFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Distance Radius')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Set Search Radius', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text('Results will be shown within your selected distance from the chosen area.', style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.5)),
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                  color: AppColors.primary.withOpacity(0.07),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('25', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    Text('kilometers', style: TextStyle(fontSize: 13, color: AppColors.textGray, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: const [
                Text('10 km', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                Spacer(),
                Text('100 km', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGray)),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.border,
                thumbColor: Colors.white,
                overlayColor: AppColors.primary.withOpacity(0.15),
                valueIndicatorColor: AppColors.primary,
                valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              child: Slider(
                value: 25,
                min: 10,
                max: 100,
                divisions: 18,
                label: '25 km',
                onChanged: (_) {},
              ),
            ),
            const SizedBox(height: 40),
            const Text('Preset Ranges', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [10, 15, 20, 25, 30, 50, 75, 100].map((v) {
                final selected = v == 25;
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.5),
                    ),
                    child: Text('$v km', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textDark)),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Apply Filter'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
