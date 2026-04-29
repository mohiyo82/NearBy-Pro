import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';
import 'manage_applicants_screen.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    if (_user == null) {
      return const Scaffold(body: Center(child: Text("Please log in to view dashboard")));
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Company Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notification-settings'),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          if (!snapshot.data!.exists) {
            return const Center(child: Text('User profile not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final companyName = userData['companyName'] ?? userData['name'] ?? 'Your Company';
          final location = userData['location'] ?? 'Location not set';
          final logoUrl = userData['photoUrl'] ?? '';
          final followersCount = userData['followersCount'] ?? 0;

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCompanyHeader(companyName, location, logoUrl),
                  const SizedBox(height: 28),
                  _buildStatsRow(followersCount, dbService),
                  const SizedBox(height: 32),
                  const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                  const SizedBox(height: 16),
                  _buildActionGrid(),
                  
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Latest Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/company-profile', arguments: _user?.uid), 
                        child: const Text('View All', style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRecentPosts(),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Job Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/education-details'), 
                        child: const Text('See All', style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRecentJobs(),
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/post-job'),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Post a Job', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCompanyHeader(String name, String location, String logoUrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), 
            blurRadius: 15, 
            offset: const Offset(0, 6)
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1B4332).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
              image: (logoUrl.isNotEmpty) ? DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.cover) : null,
            ),
            child: (logoUrl.isEmpty) ? const Icon(Icons.business_rounded, color: Color(0xFF1B4332), size: 32) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: const Color(0xFF1B4332),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/company-profile', arguments: _user?.uid),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int followersCount, DatabaseService dbService) {
    return Row(
      children: [
        _buildStatCardStatic('Followers', Icons.people_outline, Colors.blue, followersCount.toString()),
        const SizedBox(width: 12),
        _buildStatCardFromDb('Searches', Icons.search_rounded, Colors.orange, 'search_history', dbService),
        const SizedBox(width: 12),
        _buildStatCardFromDb('Applied', Icons.send_rounded, Colors.green, 'applications', dbService),
      ],
    );
  }

  Widget _buildStatCardStatic(String label, IconData icon, Color color, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardFromDb(String label, IconData icon, Color color, String collection, DatabaseService dbService) {
    return Expanded(
      child: StreamBuilder<int>(
        stream: dbService.getCollectionCount(collection),
        builder: (context, snapshot) {
          String count = (snapshot.hasData) ? snapshot.data!.toString() : '0';
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(height: 12),
                Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.3,
      children: [
        _buildActionItem('Create Post', Icons.post_add_rounded, Colors.purple, () => Navigator.pushNamed(context, '/create-post')),
        _buildActionItem('Post Job', Icons.work_outline_rounded, Colors.indigo, () => Navigator.pushNamed(context, '/post-job')),
        _buildActionItem('Analytics', Icons.analytics_outlined, Colors.teal, () => Navigator.pushNamed(context, '/profile-analytics')),
        _buildActionItem('Settings', Icons.settings_outlined, Colors.blueGrey, () => Navigator.pushNamed(context, '/settings')),
      ],
    );
  }

  Widget _buildActionItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPosts() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: _user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading posts.'));
        }
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        // Filter out automatically generated job posts from the social feed
        final posts = snapshot.data!.docs.where((doc) {
          final d = doc.data() as Map<String, dynamic>;
          return d['type'] != 'job';
        }).toList();

        // Manual sort to avoid index requirement
        posts.sort((a, b) {
          final t1 = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
          final t2 = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
          return t2.compareTo(t1);
        });

        if (posts.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(20), 
              border: Border.all(color: AppColors.border)
            ),
            child: const Center(
              child: Text('No social posts yet. Click "Create Post" to upload.', style: TextStyle(color: Colors.grey))
            ),
          );
        }

        final displayPosts = posts.take(3).toList();

        return Column(
          children: displayPosts.map((doc) {
            final post = doc.data() as Map<String, dynamic>;
            final time = post['timestamp'] != null ? DateFormat('MMM d').format((post['timestamp'] as Timestamp).toDate()) : '';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: (post['imageUrl'] != null && post['imageUrl'].isNotEmpty)
                    ? Image.network(post['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                    : Container(width: 50, height: 50, color: Colors.grey[100], child: const Icon(Icons.article_outlined, color: Colors.grey)),
                ),
                title: Text(post['content'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                onTap: () => Navigator.pushNamed(context, '/company-profile', arguments: _user?.uid),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecentJobs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('companyId', isEqualTo: _user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading jobs.'));
        }
        
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final jobs = snapshot.data!.docs.toList();
        // Manual sort to avoid index requirement
        jobs.sort((a, b) {
          final t1 = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp? ?? Timestamp.now();
          final t2 = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp? ?? Timestamp.now();
          return t2.compareTo(t1);
        });

        if (jobs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(Icons.work_history_outlined, size: 54, color: Colors.grey.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                const Text('No active job posts', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                const Text('Your latest job openings will appear here.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        }

        final displayJobs = jobs.take(5).toList();

        return Column(
          children: displayJobs.map((doc) {
            final job = doc.data() as Map<String, dynamic>;
            final jobId = doc.id;
            final time = job['createdAt'] != null ? DateFormat('MMM d').format((job['createdAt'] as Timestamp).toDate()) : '';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B4332).withValues(alpha: 0.08), 
                        borderRadius: BorderRadius.circular(14)
                      ),
                      child: const Icon(Icons.work_outline, color: Color(0xFF1B4332), size: 22),
                    ),
                    title: Text(job['title'] ?? 'Job Title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${job['jobType'] ?? ''} • ${job['applicantCount'] ?? 0} applied', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(context, '/result-detail', arguments: job),
                  ),
                  const Divider(height: 1, indent: 70),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageApplicantsScreen(jobId: jobId, jobTitle: job['title'] ?? 'Job'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.people_outline, size: 18),
                        label: const Text('Manage Applicants', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1B4332),
                          backgroundColor: const Color(0xFF1B4332).withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
