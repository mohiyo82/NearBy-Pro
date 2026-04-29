import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _toggleMode(BuildContext context, String currentMode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newMode = currentMode == 'company' ? 'user' : 'company';
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'activeMode': newMode,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switched to ${newMode.toUpperCase()} mode')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final userData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
          String name = userData['name'] ?? "User";
          String email = user?.email ?? "";
          String? photoUrl = userData['photoUrl'];
          String activeMode = userData['activeMode'] ?? 'user';

          // Simplified query to avoid index issues
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('company_registrations')
                .where('userId', isEqualTo: user?.uid)
                .snapshots(),
            builder: (context, regSnapshot) {
              String companyStatus = userData['companyStatus'] ?? 'none';
              String companyName = userData['tempCompanyName'] ?? 'Your Company';
              
              if (regSnapshot.hasData && regSnapshot.data!.docs.isNotEmpty) {
                // Get the latest submission by finding max timestamp in code
                final docs = regSnapshot.data!.docs;
                final latestDoc = docs.first.data() as Map<String, dynamic>;
                companyStatus = latestDoc['status'] ?? companyStatus;
                companyName = latestDoc['companyName'] ?? companyName;
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ─── TOP PROFILE CARD ───
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/profile-preview'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF1B4332).withValues(alpha: 0.1),
                            backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
                            child: (photoUrl == null || photoUrl.isEmpty) ? const Icon(Icons.person, size: 32, color: Color(0xFF1B4332)) : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(activeMode == 'company' ? companyName : name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                                Text(email, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: activeMode == 'company' ? const Color(0xFF1B4332).withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    activeMode == 'company' ? 'BUSINESS MODE' : 'PERSONAL MODE', 
                                    style: TextStyle(fontSize: 10, color: activeMode == 'company' ? const Color(0xFF1B4332) : Colors.blue, fontWeight: FontWeight.bold)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── MODE SWITCHER ───
                  if (companyStatus == 'verified')
                    _SettingsGroup(title: 'Account Mode', items: [
                      _SettingItem(
                        icon: activeMode == 'company' ? Icons.person_outline_rounded : Icons.business_rounded, 
                        label: activeMode == 'company' ? 'Switch to Personal Mode' : 'Switch to Company Mode', 
                        sub: activeMode == 'company' ? 'Go back to your personal profile' : 'Manage your business & jobs', 
                        color: Colors.indigo, 
                        onTap: () => _toggleMode(context, activeMode)
                      ),
                    ]),
                  const SizedBox(height: 20),

                  // ─── ACCOUNT SETTINGS ───
                  _SettingsGroup(title: 'Account Settings', items: [
                    _SettingItem(icon: Icons.lock_outline_rounded, label: 'Security', sub: 'Change password & security', color: Colors.blue.shade600, onTap: () => Navigator.pushNamed(context, '/security-settings')),
                    _SettingItem(icon: Icons.privacy_tip_outlined, label: 'Privacy', sub: 'Control your visibility', color: Colors.teal.shade500, onTap: () => Navigator.pushNamed(context, '/privacy-settings')),
                    _SettingItem(icon: Icons.tune_rounded, label: 'General Preferences', sub: 'Language & app settings', color: Colors.orange.shade600, onTap: () => Navigator.pushNamed(context, '/general-preferences')),
                  ]),
                  const SizedBox(height: 20),

                  // ─── PREMIUM & BUSINESS ───
                  _SettingsGroup(title: 'Business & Subscription', items: [
                    _SettingItem(icon: Icons.play_circle_outline_rounded, label: 'Subscription Plans', sub: 'Manage pro features', color: Colors.purple.shade500, onTap: () => Navigator.pushNamed(context, '/subscriptions')),
                    if (companyStatus != 'verified')
                      _SettingItem(
                        icon: Icons.business_rounded, 
                        label: companyStatus == 'pending' ? 'Verification Pending' : 'Register Your Company', 
                        sub: companyStatus == 'pending' ? 'Review is in progress' : 'Get authority to post jobs', 
                        color: const Color(0xFF1B4332), 
                        onTap: companyStatus == 'pending' ? () {} : () => Navigator.pushNamed(context, '/register-company')
                      ),
                  ]),
                  const SizedBox(height: 20),

                  // ─── SUPPORT ───
                  _SettingsGroup(title: 'Support', items: [
                    _SettingItem(icon: Icons.palette_outlined, label: 'Appearance', sub: 'Theme & Colors', color: Colors.green.shade600, onTap: () => Navigator.pushNamed(context, '/theme-settings')),
                    _SettingItem(icon: Icons.notifications_none_rounded, label: 'Notifications', sub: 'Alerts & Sounds', color: Colors.red.shade400, onTap: () => Navigator.pushNamed(context, '/notification-settings')),
                  ]),
                  const SizedBox(height: 20),

                  // ─── DANGER ZONE ───
                  _SettingsGroup(title: 'Danger Zone', items: [
                    _SettingItem(icon: Icons.logout_rounded, label: 'Logout', sub: 'Sign out of your account', color: Colors.red.shade600, onTap: () => _showLogoutDialog(context)),
                    _SettingItem(icon: Icons.delete_forever_rounded, label: 'Delete Account', sub: 'Permanently remove your data', color: Colors.red.shade600, onTap: () => Navigator.pushNamed(context, '/delete-account')),
                  ]),

                  const SizedBox(height: 120), 
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
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
        padding: const EdgeInsets.only(left: 4, bottom: 12), 
        child: Text(title, 
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF6B7280), letterSpacing: 0.3))
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: items.asMap().entries.map((e) => Column(
            children: [
              e.value, 
              if (e.key < items.length - 1) 
                const Divider(height: 1, indent: 64, color: Color(0xFFF3F4F6))
            ]
          )).toList()
        ),
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      width: 42, 
      height: 42, 
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 22)
    ),
    title: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
    subtitle: sub != null ? Text(sub!, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))) : null,
    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 22),
    onTap: onTap,
  );
}
