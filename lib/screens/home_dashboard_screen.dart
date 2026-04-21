import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  static const List<_CategoryItem> _categories = [
    _CategoryItem('Hospitals', Icons.local_hospital_rounded, Color(0xFFE53935)),
    _CategoryItem('Schools', Icons.school_rounded, Color(0xFFF57C00)),
    _CategoryItem('Software Houses', Icons.computer_rounded, AppColors.primary),
    _CategoryItem('Factories', Icons.factory_rounded, Color(0xFF546E7A)),
    _CategoryItem('Banks', Icons.account_balance_rounded, AppColors.secondary),
    _CategoryItem('Hotels', Icons.hotel_rounded, Color(0xFF7B1FA2)),
    _CategoryItem('Restaurants', Icons.restaurant_rounded, Color(0xFFD84315)),
    _CategoryItem('More', Icons.grid_view_rounded, AppColors.textGray),
  ];

  void _onBottomNavTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    
    switch (index) {
      case 1: Navigator.pushNamed(context, '/global-search'); break;
      case 2: Navigator.pushNamed(context, '/saved-places'); break;
      case 3: Navigator.pushNamed(context, '/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _authService.userDataStream(user?.uid ?? ""),
          builder: (context, snapshot) {
            final String userName = (snapshot.hasData && snapshot.data!.exists) 
                ? snapshot.data!.get('name') 
                : "User";

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(userName),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                _buildQuickStats(),
                _buildCategories(),
                _buildRecentSearches(),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Hello, $userName! 👋', style: const TextStyle(fontSize: 14, color: Colors.white70)),
                  const Text('Find Places Near You', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                const Spacer(),
                _buildNotificationIcon(),
                const SizedBox(width: 10),
                _buildProfileIcon(),
              ],
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/notification-settings'),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ),
        Positioned(top: 8, right: 8, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle))),
      ],
    );
  }

  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/settings'),
      child: Container(
        width: 44, height: 44,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(Icons.person, color: AppColors.textLight),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/global-search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: const Row(children: [
          Icon(Icons.search_rounded, color: AppColors.textGray),
          SizedBox(width: 10),
          Expanded(child: Text('Search hospitals, jobs, schools...', style: TextStyle(color: AppColors.textLight, fontSize: 14))),
          Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
        ]),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildStatItem('search_history', 'Searches', Icons.search_rounded, AppColors.primary, '/search-history'),
                const SizedBox(width: 12),
                _buildStatItem('saved_places', 'Saved', Icons.bookmark_rounded, AppColors.secondary, '/saved-places'),
                const SizedBox(width: 12),
                _buildStatItem('applications', 'Applied', Icons.send_rounded, AppColors.accent, '/contact-list'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String collection, String label, IconData icon, Color color, String route) {
    return StreamBuilder<int>(
      stream: _dbService.getCollectionCount(collection),
      builder: (context, snapshot) => _StatCard(
        icon: icon,
        label: label,
        value: (snapshot.data ?? 0).toString(),
        color: color,
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  Widget _buildCategories() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Browse by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/category-selection'),
                  child: const Text('See All', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) => _CategoryCard(item: _categories[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            StreamBuilder<QuerySnapshot>(
              stream: _dbService.searchHistoryStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const _EmptyHistoryPlaceholder();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length > 3 ? 3 : snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history, color: AppColors.textLight),
                      title: Text(data['query'] ?? "", style: const TextStyle(fontSize: 14)),
                      onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: data['query']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Optimized Stateless Widgets with const constructors
class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: item.label),
    child: Column(
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
          child: Icon(item.icon, color: item.color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(item.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1),
      ],
    ),
  );
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final VoidCallback onTap;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
          ],
        ),
      ),
    ),
  );
}

class _EmptyHistoryPlaceholder extends StatelessWidget {
  const _EmptyHistoryPlaceholder();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
    child: const Column(children: [
      Icon(Icons.history_rounded, size: 44, color: AppColors.textLight),
      SizedBox(height: 10),
      Text('No recent searches', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
    ]),
  );
}

class _CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  const _CategoryItem(this.label, this.icon, this.color);
}
