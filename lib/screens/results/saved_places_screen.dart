import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('My Saves', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Places'),
            Tab(text: 'Jobs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlacesTab(),
          _buildJobsTab(),
        ],
      ),
    );
  }

  Widget _buildPlacesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _dbService.savedPlacesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No saved places', Icons.place_outlined);

        final places = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: places.length,
          itemBuilder: (context, i) => _buildPlaceCard(places[i]),
        );
      },
    );
  }

  Widget _buildJobsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _dbService.savedJobsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No saved jobs', Icons.work_outline);

        final jobs = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, i) => _buildJobCard(jobs[i]),
        );
      },
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> p) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/result-detail', arguments: p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(_getIconData(p['cat']), color: AppColors.primary, size: 28)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p['name'] ?? 'No Name', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(p['cat'] ?? 'General', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)), const SizedBox(height: 6), Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight), const SizedBox(width: 4), Expanded(child: Text('${p['dist'] ?? "0 km"} • ${p['city'] ?? ""}', style: const TextStyle(fontSize: 12, color: AppColors.textGray), maxLines: 1, overflow: TextOverflow.ellipsis))])])),
              IconButton(onPressed: () => _dbService.toggleSavePlace(p), icon: const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 22)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final createdAt = job['createdAt'] as Timestamp?;
    final timeStr = createdAt != null ? DateFormat('MMM d').format(createdAt.toDate()) : 'Recent';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/result-detail', arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4332).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(15),
                    image: (job['companyLogo'] != null && job['companyLogo'].isNotEmpty)
                      ? DecorationImage(image: NetworkImage(job['companyLogo']), fit: BoxFit.cover)
                      : null,
                ),
                child: (job['companyLogo'] == null || job['companyLogo'].isEmpty)
                  ? const Icon(Icons.business_rounded, color: Color(0xFF1B4332), size: 28)
                  : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title'] ?? 'Job Role', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(job['companyName'] ?? 'Verified Company', style: const TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _dbService.toggleSaveJob(job),
                  icon: const Icon(Icons.bookmark_rounded, color: AppColors.secondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job['location'] ?? 'Location', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                Text(timeStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String? cat) {
    switch (cat) {
      case 'Tech': return Icons.computer_rounded;
      case 'Healthcare': return Icons.local_hospital_rounded;
      case 'Education': return Icons.school_rounded;
      case 'Finance': return Icons.account_balance_rounded;
      default: return Icons.place_rounded;
    }
  }

  Widget _buildEmptyState(String title, IconData icon) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 64, color: AppColors.textLight.withValues(alpha: 0.5)), const SizedBox(height: 16), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textGray)), const SizedBox(height: 8), const Text('Items you save will appear here', style: TextStyle(color: AppColors.textLight))]));
}
