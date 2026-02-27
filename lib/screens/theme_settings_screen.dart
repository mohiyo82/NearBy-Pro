import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

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
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((c) {
                final isSelected = _selectedPrimary == c;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPrimary = c),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? AppColors.textDark : Colors.transparent, width: 3),
                      boxShadow: [BoxShadow(color: c.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            const Text('Font Size', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Row(children: [
              const Text('A', style: TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w600)),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  onChanged: (v) => setState(() => _fontSize = v),
                  activeColor: _selectedPrimary,
                  inactiveColor: AppColors.border,
                ),
              ),
              const Text('A', style: TextStyle(fontSize: 22, color: AppColors.textGray, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 28),
            const Text('Other Options', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            _buildSwitchOption('Compact Card View', 'Show more results per screen', _compactView, (v) => setState(() => _compactView = v)),
            _buildSwitchOption('Show Distance in Miles', 'Default is kilometers', _showMiles, (v) => setState(() => _showMiles = v)),
            _buildSwitchOption('Bold Labels', 'Increase label visibility', _boldLabels, (v) => setState(() => _boldLabels = v)),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Apply Changes',
              onTap: () {
                _showSnackBar('Theme updated successfully!');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 40),
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
            color: isSelected ? _selectedPrimary.withOpacity(0.08) : AppColors.surface,
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

  Widget _buildSwitchOption(String label, String sub, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
        ])),
        Switch.adaptive(value: value, onChanged: onChanged, activeColor: _selectedPrimary),
      ]),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}
