import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class JobsDiscoveryScreen extends StatefulWidget {
  const JobsDiscoveryScreen({super.key});

  @override
  State<JobsDiscoveryScreen> createState() => _JobsDiscoveryScreenState();
}

class _JobsDiscoveryScreenState extends State<JobsDiscoveryScreen> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Jobs Near You', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildAreaHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobs')
                  .where('status', isEqualTo: 'active')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading jobs.', style: TextStyle(fontSize: 12)));
                }
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final jobs = snapshot.data!.docs.toList();
                // Manual sort by createdAt to avoid index requirement
                jobs.sort((a, b) {
                  final t1 = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp? ?? Timestamp.now();
                  final t2 = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp? ?? Timestamp.now();
                  return t2.compareTo(t1);
                });

                if (jobs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_history_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        const Text('No live jobs posted yet.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, i) {
                    final jobData = jobs[i].data() as Map<String, dynamic>;
                    jobData['id'] = jobs[i].id;
                    return _buildJobCard(jobData);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAreaHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: const Row(
        children: [
          Icon(Icons.rss_feed_rounded, color: Color(0xFF1B4332), size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Live Jobs Feed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Direct from verified companies', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final createdAt = job['createdAt'] as Timestamp?;
    final timeStr = createdAt != null ? DateFormat('MMM d').format(createdAt.toDate()) : 'Recent';

    return Container(
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
              StreamBuilder<bool>(
                stream: _dbService.isJobSaved(job['id']),
                builder: (context, snapshot) {
                  final isSaved = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () => _dbService.toggleSaveJob(job),
                    icon: Icon(
                      isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isSaved ? AppColors.secondary : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(job['location'] ?? 'Location', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Text(timeStr, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _badge(job['jobType'] ?? 'Full-time'),
              const SizedBox(width: 8),
              _badge(job['workMode'] ?? 'On-site'),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/result-detail', arguments: job),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4332),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 38),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }
}
