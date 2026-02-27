import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 0;

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
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/global-search');
        break;
      case 2:
        Navigator.pushNamed(context, '/saved-places');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Hello, User! 👋', style: TextStyle(fontSize: 14, color: Colors.white70)),
                          const Text('Find Places Near You', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                        ]),
                        const Spacer(),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/notification-settings'),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                                child: const Icon(Icons.notifications_outlined, color: Colors.white),
                              ),
                            ),
                            Positioned(top: 8, right: 8, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle))),
                          ],
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/settings'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.person, color: AppColors.textLight),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/global-search'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          const Icon(Icons.search_rounded, color: AppColors.textGray),
                          const SizedBox(width: 10),
                          const Expanded(child: Text('Search hospitals, jobs, schools...', style: TextStyle(color: AppColors.textLight, fontSize: 14))),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/advanced-filters'),
                            child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18)),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      const Icon(Icons.location_on_rounded, size: 16, color: Colors.white70),
                      const SizedBox(width: 4),
                      const Text('Your City • 25 km radius', style: TextStyle(fontSize: 13, color: Colors.white70)),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/city-selection'),
                        child: const Text('Change', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.search_rounded,
                          label: 'Searches',
                          value: '0',
                          color: AppColors.primary,
                          onTap: () => Navigator.pushNamed(context, '/search-history'),
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          icon: Icons.bookmark_rounded,
                          label: 'Saved',
                          value: '0',
                          color: AppColors.secondary,
                          onTap: () => Navigator.pushNamed(context, '/saved-places'),
                        ),
                        const SizedBox(width: 12),
                        _StatCard(
                          icon: Icons.send_rounded,
                          label: 'Applied',
                          value: '0',
                          color: AppColors.accent,
                          onTap: () => Navigator.pushNamed(context, '/contact-list'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.85,
                      children: _categories.map((c) => _CategoryCard(item: c)).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/search-history'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        child: const Column(children: [
                          Icon(Icons.history_rounded, size: 44, color: AppColors.textLight),
                          SizedBox(height: 10),
                          Text('No recent searches', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
                          SizedBox(height: 4),
                          Text('Your search history will appear here', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/global-search'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.search_rounded, color: Colors.white),
        label: const Text('Quick Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  const _CategoryItem(this.label, this.icon, this.color);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/results-list');
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
          child: Icon(item.icon, color: item.color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(item.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 2),
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
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
          ],
        ),
      ),
    ),
  );
}
