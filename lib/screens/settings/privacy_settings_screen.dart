import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  String _profileVisibility = 'Public';
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    if (_user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
      if (doc.exists && doc.data()!.containsKey('privacy')) {
        final privacy = doc.data()!['privacy'] as Map<String, dynamic>;
        setState(() {
          _profileVisibility = privacy['profileVisibility'] ?? 'Public';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateVisibility(String value) async {
    setState(() => _profileVisibility = value);
    if (_user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(_user?.uid).update({
      'privacy.profileVisibility': value,
    });
  }

  void _showVisibilityBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text('Profile Visibility', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text('Choose who can see your profile and details.', style: TextStyle(color: AppColors.textGray, fontSize: 13)),
            ),
            const SizedBox(height: 16),
            _buildVisibilityOption(Icons.public_rounded, 'Public', 'Anyone on NearBy Pro can see your profile.'),
            _buildVisibilityOption(Icons.lock_outline_rounded, 'Private', 'Only you can see your profile.'),
            _buildVisibilityOption(Icons.people_outline_rounded, 'Followers', 'Only people you follow can see your profile.'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityOption(IconData icon, String title, String sub) {
    bool isSelected = _profileVisibility == title;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textGray, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
      onTap: () {
        _updateVisibility(title);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Privacy Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Profile Visibility', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textGray)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16), 
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.visibility_outlined, color: AppColors.primary, size: 22),
                  ),
                  title: const Text('Who can see my profile?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  subtitle: Text(_profileVisibility, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _showVisibilityBottomSheet,
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Changing this setting affects your visibility in search results and career matches.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGray),
                ),
              ),
            ],
          ),
    );
  }
}
