import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  String _profileVisibility = 'Public';
  bool _showEmail = true;
  bool _showPhone = false;
  bool _showLocation = true;
  bool _allowAIRecommendations = true;
  bool _readReceipts = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showVisibilityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Visibility'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption('Public', 'Anyone can see your profile and experience'),
            _buildRadioOption('Private', 'Only you can see your profile'),
            _buildRadioOption('Organizations Only', 'Only registered companies can view you'),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value, String subtitle) {
    return RadioListTile<String>(
      title: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      groupValue: _profileVisibility,
      activeColor: AppColors.primary,
      onChanged: (val) {
        setState(() => _profileVisibility = val!);
        Navigator.pop(context);
        _showSnackBar('Visibility updated to $val');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Profile Visibility',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildPrivacyCard([
            _PrivacyItem(
              icon: Icons.visibility_outlined,
              title: 'Who can see my profile?',
              subtitle: _profileVisibility,
              onTap: _showVisibilityDialog,
            ),
          ]),
          const SizedBox(height: 24),
          const Text('Contact Information',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildPrivacyCard([
            _buildToggleItem(
              icon: Icons.email_outlined,
              title: 'Show Email Address',
              subtitle: 'Allow others to see your email',
              value: _showEmail,
              onChanged: (v) => setState(() => _showEmail = v),
            ),
            _buildToggleItem(
              icon: Icons.phone_outlined,
              title: 'Show Phone Number',
              subtitle: 'Allow others to see your phone',
              value: _showPhone,
              onChanged: (v) => setState(() => _showPhone = v),
            ),
          ]),
          const SizedBox(height: 24),
          const Text('Discovery & Personalization',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildPrivacyCard([
            _buildToggleItem(
              icon: Icons.location_on_outlined,
              title: 'Approximate Location',
              subtitle: 'Show nearby area instead of exact address',
              value: _showLocation,
              onChanged: (v) => setState(() => _showLocation = v),
            ),
            _buildToggleItem(
              icon: Icons.auto_awesome_outlined,
              title: 'AI Recommendations',
              subtitle: 'Use profile data for better matches',
              value: _allowAIRecommendations,
              onChanged: (v) => setState(() => _allowAIRecommendations = v),
            ),
          ]),
          const SizedBox(height: 24),
          const Text('Interactions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildPrivacyCard([
            _buildToggleItem(
              icon: Icons.checklist_rtl_rounded,
              title: 'Application Status Receipts',
              subtitle: 'Let organizations know when you view their responses',
              value: _readReceipts,
              onChanged: (v) => setState(() => _readReceipts = v),
            ),
            _PrivacyItem(
              icon: Icons.block_outlined,
              title: 'Blocked Organizations',
              subtitle: 'Manage companies you\'ve restricted',
              onTap: () => _showSnackBar('Opening blocked list...'),
            ),
          ]),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Save Privacy Settings',
            onTap: () {
              _showSnackBar('Privacy settings saved successfully!');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          return Column(
            children: [
              e.value,
              if (e.key < children.length - 1) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}
