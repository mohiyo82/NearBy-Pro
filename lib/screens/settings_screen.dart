import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── PROFILE CARD ───
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile-preview'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(16), 
                border: Border.all(color: AppColors.border),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]
              ),
              child: Row(children: [
                Container(
                  width: 60, height: 60, 
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle), 
                  child: const Icon(Icons.person, size: 32, color: AppColors.primary)
                ),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Mohiyo Din Attari', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  Text('mohiyodin27@gmail.com', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                  SizedBox(height: 4),
                  Text('View & Edit Profile', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
              ]),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // ─── ACCOUNT SETTINGS GROUP ───
          _SettingsGroup(title: 'Account Settings', items: [
            _SettingItem(
              icon: Icons.person_outline_rounded, 
              label: 'My Profile', 
              sub: 'Preview and update your details', 
              color: AppColors.primary, 
              onTap: () => Navigator.pushNamed(context, '/profile-preview'),
            ),
            _SettingItem(
              icon: Icons.lock_outline_rounded, 
              label: 'Security', 
              sub: 'Change password & security', 
              color: AppColors.secondary, 
              onTap: () => Navigator.pushNamed(context, '/security-settings'),
            ),
            _SettingItem(
              icon: Icons.privacy_tip_outlined, 
              label: 'Privacy', 
              sub: 'Control your visibility', 
              color: Colors.teal, 
              onTap: () => Navigator.pushNamed(context, '/privacy-settings'), 
            ),
          ]),

          const SizedBox(height: 16),
          
          // ─── APP PREFERENCES ───
          _SettingsGroup(title: 'Preferences', items: [
            _SettingItem(
              icon: Icons.palette_rounded, 
              label: 'Appearance', 
              sub: 'Theme & Colors', 
              color: AppColors.primary, 
              onTap: () => Navigator.pushNamed(context, '/theme-settings'),
            ),
            _SettingItem(
              icon: Icons.notifications_active_outlined, 
              label: 'Notifications', 
              sub: 'Alerts & Sounds', 
              color: AppColors.warning, 
              onTap: () => Navigator.pushNamed(context, '/notification-settings'),
            ),
            _SettingItem(
              icon: Icons.subscriptions_rounded, 
              label: 'Subscription Plans', 
              sub: 'Manage your pro features', 
              color: Colors.purple, 
              onTap: () => Navigator.pushNamed(context, '/subscriptions'),
            ),
          ]),

          const SizedBox(height: 16),
          
          // ─── SUPPORT ───
          _SettingsGroup(title: 'Support', items: [
            _SettingItem(
              icon: Icons.help_outline_rounded, 
              label: 'Help Center', 
              sub: 'Get assistance', 
              color: AppColors.accent, 
              onTap: () => Navigator.pushNamed(context, '/help-support'),
            ),
            _SettingItem(
              icon: Icons.info_outline_rounded, 
              label: 'About App', 
              sub: 'v1.0.0', 
              color: AppColors.textGray, 
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ]),

          const SizedBox(height: 16),
          
          // ─── DANGER ZONE ───
          _SettingsGroup(title: 'Danger Zone', items: [
            _SettingItem(
              icon: Icons.logout_rounded, 
              label: 'Logout', 
              sub: 'Sign out of your account', 
              color: AppColors.error, 
              onTap: () => Navigator.pushNamed(context, '/logout-confirm'),
            ),
            _SettingItem(
              icon: Icons.delete_forever_rounded, 
              label: 'Delete Account', 
              sub: 'Permanently remove your data', 
              color: AppColors.error, 
              onTap: () => Navigator.pushNamed(context, '/delete-account'),
            ),
          ]),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<_SettingItem> items;
  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(color: AppColors.border)
        ),
        child: Column(children: items.asMap().entries.map((e) {
          return Column(children: [
            e.value,
            if (e.key < items.length - 1) const Divider(height: 1, indent: 58),
          ]);
        }).toList()),
      ),
    ],
  );
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sub;
  final Color color;
  final VoidCallback onTap;
  const _SettingItem({required this.icon, required this.label, this.sub, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(
      width: 38, height: 38, 
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), 
      child: Icon(icon, color: color, size: 20)
    ),
    title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
    subtitle: sub != null ? Text(sub!, style: const TextStyle(fontSize: 12, color: AppColors.textGray)) : null,
    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
    onTap: onTap,
  );
}
