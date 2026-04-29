import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoFactor = false;
  bool _faceId = true;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Security', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user?.uid)
            .collection('sessions')
            .orderBy('lastActive', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSection('Login Security', [
                _buildSwitchTile('Two-Factor Authentication', 'Add an extra layer of security', _twoFactor, (v) => setState(() => _twoFactor = v)),
                _buildSwitchTile('Face ID / Fingerprint', 'Quickly unlock your app', _faceId, (v) => setState(() => _faceId = v)),
              ]),
              const SizedBox(height: 24),
              _buildSection('Password', [
                ListTile(
                  title: const Text('Change Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Keep your account safe by changing your password regularly'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.pushNamed(context, '/change-password'),
                ),
              ]),
              const SizedBox(height: 24),
              _buildSection('Where You\'re Signed In', [
                if (!snapshot.hasData)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snapshot.data!.docs.isEmpty)
                  _buildEmptySessions()
                else
                  ...snapshot.data!.docs.map((doc) => _buildDeviceTile(doc)),
              ]),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'If you see a device you don\'t recognize, sign out to keep your account secure.',
                  style: TextStyle(fontSize: 12, color: AppColors.textGray),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySessions() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.devices_rounded, size: 40, color: AppColors.textLight),
            SizedBox(height: 8),
            Text('No active sessions found.', style: TextStyle(color: AppColors.textGray)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTile(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isCurrent = data['isCurrentDevice'] ?? false;
    final DateTime lastActive = (data['lastActive'] as Timestamp).toDate();
    final String deviceName = data['deviceName'] ?? 'Unknown Device';
    final String location = data['location'] ?? 'Unknown Location';
    final String deviceType = data['deviceType'] ?? 'phone'; // phone, desktop, tablet

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              deviceType == 'desktop' ? Icons.desktop_windows_rounded : Icons.smartphone_rounded,
              color: isCurrent ? AppColors.primary : AppColors.textGray,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  deviceName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('THIS DEVICE', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(location, style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
              Text(
                'Last active: ${DateFormat('MMM d, h:mm a').format(lastActive)}',
                style: const TextStyle(fontSize: 12, color: AppColors.textGray),
              ),
            ],
          ),
          trailing: isCurrent
            ? null
            : IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                onPressed: () => _showSignOutConfirmation(doc.id, deviceName),
              ),
          onTap: () => _showSessionDetails(data),
        ),
        const Divider(height: 1, indent: 70),
      ],
    );
  }

  void _showSessionDetails(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text('Session Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            _detailRow('Device', data['deviceName'] ?? 'Unknown'),
            _detailRow('Type', data['deviceType'] ?? 'Unknown'),
            _detailRow('Location', data['location'] ?? 'Unknown'),
            _detailRow('IP Address', data['ipAddress'] ?? 'Hidden'),
            _detailRow('First Signed In', DateFormat('MMM d, yyyy').format((data['createdAt'] as Timestamp).toDate())),
            const SizedBox(height: 20),
            if (!(data['isCurrentDevice'] ?? false))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    _signOutSession(data['id'] ?? '');
                  },
                  child: const Text('Log Out From This Device'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showSignOutConfirmation(String sessionId, String deviceName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out?'),
        content: Text('Are you sure you want to sign out from $deviceName?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _signOutSession(sessionId);
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _signOutSession(String sessionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user?.uid)
          .collection('sessions')
          .doc(sessionId)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device signed out successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign out: $e')),
        );
      }
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String sub, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
