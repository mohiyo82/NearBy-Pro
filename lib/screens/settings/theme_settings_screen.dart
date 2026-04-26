import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  String _selectedMode = 'Light Mode';
  Color _selectedPrimary = AppColors.primary;
  double _fontSize = 0.5;
  bool _compactView = false;
  bool _showMiles = false;
  bool _boldLabels = true;

  final List<Color> _colorOptions = [
    AppColors.primary,
    AppColors.secondary,
    const Color(0xFF7B1FA2),
    const Color(0xFFD84315),
    const Color(0xFF00695C),
    const Color(0xFF1565C0),
    const Color(0xFFF57C00),
    const Color(0xFF424242),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Theme & Appearance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Color Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Row(children: [
              _buildModeCard(Icons.wb_sunny_rounded, 'Light Mode'),
              const SizedBox(width: 12),
              _buildModeCard(Icons.dark_mode_rounded, 'Dark Mode'),
              const SizedBox(width: 12),
              _buildModeCard(Icons.phone_android_rounded, 'System'),
            ]),
            const SizedBox(height: 28),
            const Text('Primary Color', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: _colorOptions.map((c) {
                final isSelected = _selectedPrimary == c;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPrimary = c),
                  child: Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: isSelected ? AppColors.textDark : Colors.transparent, width: 3)),
                    child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            const Text('Font Size', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Row(children: [
              const Text('A', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Expanded(child: Slider(value: _fontSize, onChanged: (v) => setState(() => _fontSize = v), activeColor: _selectedPrimary)),
              const Text('A', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Changes'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(IconData icon, String label) {
    final isSelected = _selectedMode == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? _selectedPrimary.withValues(alpha: 0.08) : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? _selectedPrimary : AppColors.border, width: isSelected ? 2 : 1),
          ),
          child: Column(children: [
            Icon(icon, color: isSelected ? _selectedPrimary : AppColors.textGray, size: 28),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? _selectedPrimary : AppColors.textGray)),
          ]),
        ),
      ),
    );
  }
}
