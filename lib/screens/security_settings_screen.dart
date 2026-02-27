import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _loginAlertsEnabled = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _changePassword() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Old Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                _showSnackBar('Password changed successfully');
                Navigator.pop(context);
              } else {
                _showSnackBar('Passwords do not match');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLoginDevices() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Where You\'re Logged In',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildDeviceItem('Samsung Galaxy S23', 'Lahore, Pakistan • Active Now', true),
            _buildDeviceItem('iPhone 14 Pro', 'Karachi, Pakistan • 2 days ago', false),
            _buildDeviceItem('Windows PC - Chrome', 'London, UK • 1 week ago', false),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Log Out From All Devices',
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Logged out from all other devices');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(String device, String details, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isActive ? Icons.phone_android_rounded : Icons.laptop_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(details, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
          if (!isActive)
            TextButton(
              onPressed: () => _showSnackBar('Device removed'),
              child: const Text('Remove', style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Login Security',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildSecurityCard([
            _SecurityItem(
              icon: Icons.key_rounded,
              title: 'Change Password',
              subtitle: 'Last changed 3 months ago',
              onTap: _changePassword,
            ),
            _SecurityItem(
              icon: Icons.devices_rounded,
              title: 'Where You\'re Logged In',
              subtitle: 'Manage your active sessions',
              onTap: _showLoginDevices,
            ),
          ]),
          const SizedBox(height: 24),
          const Text('Advanced Security',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildSecurityCard([
            _buildToggleItem(
              icon: Icons.phonelink_lock_rounded,
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security',
              value: _twoFactorEnabled,
              onChanged: (v) => setState(() => _twoFactorEnabled = v),
            ),
            _buildToggleItem(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID',
              value: _biometricEnabled,
              onChanged: (v) => setState(() => _biometricEnabled = v),
            ),
            _buildToggleItem(
              icon: Icons.notifications_active_outlined,
              title: 'Login Alerts',
              subtitle: 'Get notified of new logins',
              value: _loginAlertsEnabled,
              onChanged: (v) => setState(() => _loginAlertsEnabled = v),
            ),
          ]),
          const SizedBox(height: 24),
          const Text('Data Protection',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textGray)),
          const SizedBox(height: 12),
          _buildSecurityCard([
            _SecurityItem(
              icon: Icons.download_for_offline_outlined,
              title: 'Download My Data',
              subtitle: 'Get a copy of your information',
              onTap: () => _showSnackBar('Preparing your data... You will receive an email soon.'),
            ),
            _SecurityItem(
              icon: Icons.delete_outline_rounded,
              title: 'Deactivate Account',
              subtitle: 'Temporarily disable your profile',
              color: Colors.red,
              onTap: () => Navigator.pushNamed(context, '/delete-account'),
            ),
          ]),
          const SizedBox(height: 40),
          PrimaryButton(
            label: 'Save Security Settings',
            onTap: () => _showSnackBar('Security settings updated successfully!'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard(List<Widget> children) {
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

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color != null ? color : AppColors.textDark)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}
