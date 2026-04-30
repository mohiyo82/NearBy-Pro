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
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJobsTab(),
                _buildPlacesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          AppBar(
            title: const Text('My Saves', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 22)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white.withOpacity(0.9),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Jobs'),
                  Tab(text: 'Places'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _dbService.savedPlacesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No saved places', Icons.location_on_rounded);

        final places = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          physics: const BouncingScrollPhysics(),
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
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return _buildEmptyState('No saved jobs', Icons.work_rounded);

        final jobs = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          physics: const BouncingScrollPhysics(),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: -25,
                top: -25,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withOpacity(0.08), AppColors.primary.withOpacity(0.15)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(_getIconData(p['cat']), color: AppColors.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['name'] ?? 'No Name', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(p['cat'] ?? 'General', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Expanded(child: Text('${p['dist'] ?? "0 km"} • ${p['city'] ?? ""}', style: const TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis))
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _dbService.toggleSavePlace(p),
                      icon: const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 28),
                    ),
                  ],
                ),
              ),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      image: (job['companyLogo'] != null && job['companyLogo'].isNotEmpty)
                        ? DecorationImage(image: NetworkImage(job['companyLogo']), fit: BoxFit.cover)
                        : null,
                    ),
                    child: (job['companyLogo'] == null || job['companyLogo'].isEmpty)
                      ? const Icon(Icons.business_center_rounded, color: AppColors.primary, size: 30)
                      : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job['title'] ?? 'Job Role', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(job['companyName'] ?? 'Verified Company', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _dbService.toggleSaveJob(job),
                    icon: const Icon(Icons.bookmark_rounded, color: AppColors.secondary, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textLight),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        job['location'] ?? 'Location',
                        style: const TextStyle(fontSize: 13, color: AppColors.textGray, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      child: Text(timeStr, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      case 'Food': return Icons.restaurant_rounded;
      case 'Travel': return Icons.hotel_rounded;
      default: return Icons.place_rounded;
    }
  }

  Widget _buildEmptyState(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 80, color: AppColors.primary.withOpacity(0.2)),
          ),
          const SizedBox(height: 32),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Your saved items will appear here once you find something you like!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGray, fontSize: 15, height: 1.5),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Switches to Home tab in the MainWrapper
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 4,
            ),
            child: const Text('Start Exploring', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
