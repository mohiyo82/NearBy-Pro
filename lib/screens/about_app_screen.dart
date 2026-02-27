import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.search_rounded, 'title': 'Smart Search', 'desc': 'Find any place or company by type, city, and radius'},
      {'icon': Icons.map_rounded, 'title': 'Map & List Views', 'desc': 'Browse results visually on map or in a clean list'},
      {'icon': Icons.description_rounded, 'title': 'Resume Manager', 'desc': 'Upload and manage multiple resumes in one place', 'route': '/resume-manager'},
      {'icon': Icons.bookmark_rounded, 'title': 'Save & Track', 'desc': 'Bookmark places and track your job applications', 'route': '/saved-places'},
    ];

    final links = [
      {'icon': Icons.privacy_tip_rounded, 'label': 'Privacy Policy', 'action': () => _showPolicy(context, 'Privacy Policy')},
      {'icon': Icons.gavel_rounded, 'label': 'Terms of Service', 'action': () => _showPolicy(context, 'Terms of Service')},
      {'icon': Icons.article_rounded, 'label': 'Open Source Licenses', 'action': () => showLicensePage(context: context)},
      {'icon': Icons.rate_review_rounded, 'label': 'Rate This App', 'action': () => _showSnackBar(context, 'Redirecting to App Store...')},
      {'icon': Icons.share_rounded, 'label': 'Share NearBy Pro', 'action': () => _showSnackBar(context, 'Opening share menu...')},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('About App')),
      body: ListView(
        children: [
          // Hero header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(children: [
              Container(width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 6))]),
                child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 44),
              ),
              const SizedBox(height: 16),
              const Text('NearBy Pro', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Smart Location & Career Finder', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85))),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('Version 1.0.0 (Build 100)', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: const Text(
                    'NearBy Pro helps students, job seekers, and professionals discover places and opportunities nearby. Search hospitals, schools, software houses, factories and more — then connect directly.',
                    style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.6),
                  ),
                ),
                const SizedBox(height: 20),

                // Features grid
                const Text('Key Features', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8,
                  children: features.map((f) => GestureDetector(
                    onTap: f.containsKey('route') ? () => Navigator.pushNamed(context, f['route'] as String) : null,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(f['icon'] as IconData, color: AppColors.primary, size: 22),
                        const SizedBox(height: 8),
                        Text(f['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                        const SizedBox(height: 4),
                        Text(f['desc'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textGray, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 24),

                // Links
                const Text('Legal & More', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Column(
                    children: links.asMap().entries.map((e) {
                      final isLast = e.key == links.length - 1;
                      final l = e.value;
                      return Column(children: [
                        ListTile(
                          leading: Icon(l['icon'] as IconData, color: AppColors.primary, size: 22),
                          title: Text(l['label'] as String, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textLight),
                          onTap: l['action'] as VoidCallback,
                        ),
                        if (!isLast) const Divider(height: 1, indent: 54, color: AppColors.border),
                      ]);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(child: Text('Made with ❤️ in Pakistan\n© 2025 NearBy Pro. All rights reserved.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.6))),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPolicy(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: Text('NearBy Pro $title details would go here. We value your trust and ensure your data is handled professionally.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', style: TextStyle(color: AppColors.textGray, height: 1.6)))),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ]),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }
}
