import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class ProfileAnalyticsScreen extends StatelessWidget {
  const ProfileAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    if (user == null) return const Scaffold(body: Center(child: Text('Please log in')));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Profile Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          
          // Stats from user document
          final int profileViews = data['profileViews'] ?? 0;
          final int savedPlaces = (data['savedPlacesCount'] ?? 0) + (data['savedJobsCount'] ?? 0);
          final int searches = data['searchCount'] ?? 0;
          final int applications = data['applicationsCount'] ?? 0;

          // Profile Strength Calculation
          bool hasPhoto = (data['photoUrl'] != null && data['photoUrl'].toString().isNotEmpty);
          bool hasBio = (data['bio'] != null && data['bio'].toString().isNotEmpty);
          bool hasEdu = (data['education'] as List? ?? []).isNotEmpty;
          bool hasWork = (data['experience'] as List? ?? []).isNotEmpty;
          bool hasResume = (data['resumeUrl'] != null && data['resumeUrl'].toString().isNotEmpty);
          
          int score = 0;
          if (hasPhoto) score += 20;
          if (hasBio) score += 20;
          if (hasEdu) score += 20;
          if (hasWork) score += 20;
          if (hasResume) score += 20;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: _StatCard2(title: 'Profile Views', value: profileViews.toString(), icon: Icons.visibility_rounded, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard2(title: 'Applications', value: applications.toString(), icon: Icons.send_rounded, color: AppColors.secondary)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _StatCard2(title: 'Saved Places', value: savedPlaces.toString(), icon: Icons.bookmark_rounded, color: AppColors.accent)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard2(title: 'Searches Done', value: searches.toString(), icon: Icons.search_rounded, color: const Color(0xFF7E57C2))),
                ]),
                const SizedBox(height: 32),
                const Text('Profile Strength', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(20), 
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        const Text('Overall Completeness', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        const Spacer(),
                        Text('$score%', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 20)),
                      ]),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: score / 100, 
                        backgroundColor: AppColors.border.withOpacity(0.5), 
                        valueColor: AlwaysStoppedAnimation<Color>(score > 70 ? AppColors.primary : Colors.orange), 
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 24),
                      _StrengthRow('Profile Photo', hasPhoto),
                      _StrengthRow('Professional Bio', hasBio),
                      _StrengthRow('Education History', hasEdu),
                      _StrengthRow('Work Experience', hasWork),
                      _StrengthRow('Resume / CV', hasResume),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Activity Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border.withOpacity(0.5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Last 7 Days', style: TextStyle(color: AppColors.textGray, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (i) {
                          // Mock data for chart visualization
                          double height = [30.0, 50.0, 20.0, 80.0, 45.0, 60.0, 90.0][i];
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(children: [
                                Container(
                                  height: height,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                    borderRadius: BorderRadius.circular(6)
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][i], style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard2 extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard2({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(20), 
      border: Border.all(color: AppColors.border.withOpacity(0.5)),
      boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 16),
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark)),
        Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _StrengthRow extends StatelessWidget {
  final String label;
  final bool done;
  const _StrengthRow(this.label, this.done);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(done ? Icons.check_circle_rounded : Icons.info_outline_rounded, color: done ? AppColors.success : Colors.orange.withOpacity(0.5), size: 20),
      const SizedBox(width: 12),
      Text(label, style: TextStyle(fontSize: 14, color: done ? AppColors.textDark : AppColors.textGray, fontWeight: done ? FontWeight.w600 : FontWeight.w400)),
      const Spacer(),
      if (done) const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 16),
    ]),
  );
}
