import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DistanceFilterScreen extends StatefulWidget {
  final double initialRadius;
  const DistanceFilterScreen({super.key, this.initialRadius = 25});

  @override
  State<DistanceFilterScreen> createState() => _DistanceFilterScreenState();
}

class _DistanceFilterScreenState extends State<DistanceFilterScreen> {
  late double _currentRadius;

  @override
  void initState() {
    super.initState();
    _currentRadius = widget.initialRadius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Distance Radius'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Set Search Radius', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text('Results will be shown within your selected distance from your current location.', style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.6)),
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                  color: AppColors.primary.withValues(alpha: 0.07)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_currentRadius.round().toString(), style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const Text('kilometers', style: TextStyle(fontSize: 13, color: AppColors.textGray, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Row(children: [
              Text('1 km', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGray)),
              Spacer(),
              Text('100 km', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGray)),
            ]),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.border,
                thumbColor: Colors.white,
                overlayColor: AppColors.primary.withValues(alpha: 0.15),
                valueIndicatorColor: AppColors.primary,
                valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
              ),
              child: Slider(
                value: _currentRadius,
                min: 1,
                max: 100,
                divisions: 99,
                label: '${_currentRadius.round()} km',
                onChanged: (val) {
                  setState(() => _currentRadius = val);
                }
              ),
            ),
            const SizedBox(height: 40),
            const Text('Preset Ranges', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [5, 10, 20, 30, 50, 75, 100].map((v) {
                final selected = _currentRadius.round() == v;
                return GestureDetector(
                  onTap: () => setState(() => _currentRadius = v.toDouble()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.5)
                    ),
                    child: Text('$v km', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textDark))
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _currentRadius),
                child: const Text('Apply Radius')
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
