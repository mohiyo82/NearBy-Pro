import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _allNotifications = true;

  // Search Alerts
  bool _newResults = true;
  bool _nearbyOpps = false;

  // Application Updates
  bool _statusChanges = true;
  bool _jobPostings = true;
  bool _interviewInvs = true;

  // General
  bool _appAnnouncements = false;
  bool _weeklyDigest = true;
  bool _marketing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Master toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('All Notifications',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('Enable or disable all notifications at once',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Switch(
                  value: _allNotifications,
                  onChanged: (val) {
                    setState(() {
                      _allNotifications = val;
                      _newResults = val;
                      _nearbyOpps = val;
                      _statusChanges = val;
                      _jobPostings = val;
                      _interviewInvs = val;
                      _appAnnouncements = val;
                      _weeklyDigest = val;
                      _marketing = val;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Colors.white.withOpacity(0.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildSection('Search Alerts', [
            _buildTile('New results for saved searches', 'Get notified when new places match your criteria', _newResults, (val) => setState(() => _newResults = val)),
            _buildTile('Nearby opportunities', 'Alerts when new companies open near you', _nearbyOpps, (val) => setState(() => _nearbyOpps = val)),
          ]),

          _buildSection('Application Updates', [
            _buildTile('Application status changes', 'Know when companies view your profile', _statusChanges, (val) => setState(() => _statusChanges = val)),
            _buildTile('New job postings', 'Matching your skills and location', _jobPostings, (val) => setState(() => _jobPostings = val)),
            _buildTile('Interview invitations', 'Immediate alerts for interview requests', _interviewInvs, (val) => setState(() => _interviewInvs = val)),
          ]),

          _buildSection('General', [
            _buildTile('App announcements', 'Feature updates and news', _appAnnouncements, (val) => setState(() => _appAnnouncements = val)),
            _buildTile('Weekly digest', 'Summary of your activity every Monday', _weeklyDigest, (val) => setState(() => _weeklyDigest = val)),
            _buildTile('Marketing & promotions', 'Tips and promotional offers', _marketing, (val) => setState(() => _marketing = val)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String header, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(header,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border)),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTile(String label, String sub, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGray, height: 1.4)),
          trailing: Switch(
            value: value,
            onChanged: _allNotifications ? onChanged : null,
            activeColor: AppColors.primary,
          ),
        ),
        if (label != 'Marketing & promotions' && label != 'Nearby opportunities' && label != 'Interview invitations')
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
      ],
    );
  }
}
