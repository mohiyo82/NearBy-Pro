import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  final PageController _bannerController = PageController();

  int _currentBanner = 0;
  Position? _userPosition;

  static const List<String> _popularSearches = [
    'Hospitals near me',
    'Software Houses',
    'Best Restaurants',
    'Schools in my area',
    'Banks',
    'Hotels',
    'Jobs',
    'Factories',
  ];

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

  static const List<_BannerItem> _banners = [
    _BannerItem(
      title: 'Explore Jobs',
      subtitle: 'Thousands of opportunities in your city',
      icon: Icons.work_rounded,
      gradientColors: [AppColors.primary, AppColors.primaryLight],
      route: '/search-loading',
      routeArg: 'Jobs',
    ),
    _BannerItem(
      title: 'Find Top Hospitals',
      subtitle: 'Verified & rated medical centers near you',
      icon: Icons.local_hospital_rounded,
      gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)],
      route: '/search-loading',
      routeArg: 'Hospitals',
    ),
    _BannerItem(
      title: 'Best Schools',
      subtitle: 'Top-rated schools & colleges nearby',
      icon: Icons.school_rounded,
      gradientColors: [Color(0xFFF57C00), Color(0xFFFFCA28)],
      route: '/search-loading',
      routeArg: 'Schools',
    ),
    _BannerItem(
      title: 'Restaurants & Cafes',
      subtitle: 'Discover great food around you',
      icon: Icons.restaurant_rounded,
      gradientColors: [Color(0xFFD84315), Color(0xFFFF7043)],
      route: '/search-loading',
      routeArg: 'Restaurants',
    ),
  ];

  static const List<_AppPost> _appPosts = [
    _AppPost(
      icon: Icons.tips_and_updates_rounded,
      color: Color(0xFFF57C00),
      tag: 'TIP',
      tagColor: Color(0xFFF57C00),
      title: 'Complete your profile',
      body: 'Add your location & preferences to get personalized results and better recommendations.',
    ),
    _AppPost(
      icon: Icons.bookmark_add_rounded,
      color: AppColors.secondary,
      tag: 'FEATURE',
      tagColor: AppColors.secondary,
      title: 'Save your favourite places',
      body: 'Tap the bookmark icon on any listing to save it for quick access later.',
    ),
    _AppPost(
      icon: Icons.notifications_active_rounded,
      color: AppColors.primary,
      tag: 'NEW',
      tagColor: AppColors.primary,
      title: 'Get notified about new listings',
      body: 'Enable notifications to stay updated when new places are added in your area.',
    ),
    _AppPost(
      icon: Icons.star_rounded,
      color: Color(0xFFFFB300),
      tag: 'REVIEW',
      tagColor: Color(0xFFFFB300),
      title: 'Rate places you have visited',
      body: 'Help the community by sharing your experience and rating places you have been to.',
    ),
  ];

  static const List<_EventItem> _placeholderEvents = [
    _EventItem(
      title: 'Job Fair 2025',
      location: 'Expo Center',
      date: '15 May',
      icon: Icons.work_outline_rounded,
      color: AppColors.primary,
    ),
    _EventItem(
      title: 'Health Camp',
      location: 'City Hospital',
      date: '18 May',
      icon: Icons.favorite_outline_rounded,
      color: Color(0xFFE53935),
    ),
    _EventItem(
      title: 'Tech Summit',
      location: 'Pearl Continental',
      date: '22 May',
      icon: Icons.computer_rounded,
      color: Color(0xFF7B1FA2),
    ),
    _EventItem(
      title: 'Food Festival',
      location: 'Packages Mall',
      date: '25 May',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFD84315),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (mounted) setState(() => _userPosition = position);
    } catch (_) {}
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
            String userName = "User";
            String? photoUrl;
            
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              userName = data['firstName'] ?? data['name'] ?? "User";
              photoUrl = data['photoUrl'];
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(userName, photoUrl),
                const SliverToBoxAdapter(child: SizedBox(height: 22)),
                _buildQuickStats(),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                _buildBannerSlider(),
                _buildSmartSuggestions(),
                _buildCategories(),
                _buildEventsNearYou(),
                _buildAppPosts(),
                _buildRecentSearches(),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String userName, String? photoUrl) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                        image: (photoUrl != null && photoUrl.isNotEmpty) ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover) : null,
                      ),
                      child: (photoUrl == null || photoUrl.isEmpty) ? Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ) : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $userName! 👋',
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        const Text(
                          'Find Places Near You',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/notification-settings'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/global-search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(children: [
          Icon(Icons.search_rounded, color: AppColors.textGray),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search hospitals, jobs, schools...',
              style: TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
          ),
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
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
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

  Widget _buildBannerSlider() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _currentBanner = i),
              itemBuilder: (context, index) {
                final b = _banners[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, b.route, arguments: b.routeArg),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: b.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: b.gradientColors.last.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: -30,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'EXPLORE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      b.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      b.subtitle,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(b.icon, color: Colors.white, size: 28),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentBanner == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentBanner == i ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartSuggestions() {
    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: _dbService.searchHistoryStream,
        builder: (context, snapshot) {
          final List<String> suggestions = [];
          if (snapshot.hasData) {
            for (final doc in snapshot.data!.docs.take(3)) {
              final data = doc.data() as Map<String, dynamic>;
              final q = (data['query'] ?? '') as String;
              if (q.isNotEmpty && !suggestions.contains(q)) suggestions.add(q);
            }
          }
          for (final p in _popularSearches) {
            if (!suggestions.contains(p) && suggestions.length < 6) suggestions.add(p);
          }
          if (suggestions.isEmpty) return const SizedBox.shrink();

          final historySet = snapshot.hasData
              ? snapshot.data!.docs.map((d) => (d.data() as Map<String, dynamic>)['query'] as String? ?? '').toSet()
              : <String>{};

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('Smart Suggestions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                ]),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: suggestions.map((s) {
                    final isHistory = historySet.contains(s);
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isHistory ? AppColors.primary.withOpacity(0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isHistory ? AppColors.primary.withOpacity(0.3) : AppColors.border),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(isHistory ? Icons.history_rounded : Icons.trending_up_rounded, size: 14, color: isHistory ? AppColors.primary : AppColors.textGray),
                          const SizedBox(width: 6),
                          Text(s, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isHistory ? AppColors.primary : AppColors.textDark)),
                        ]),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
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
                const Text(
                  'Browse by Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
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
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) => _CategoryCard(item: _categories[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsNearYou() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFFE53935)),
              const SizedBox(width: 6),
              const Text('Events Near You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _userPosition == null ? _fetchUserLocation : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _userPosition != null ? Colors.green.withOpacity(0.12) : Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _userPosition != null ? 'Location On' : 'Enable Location',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _userPosition != null ? Colors.green : Colors.orange),
                  ),
                ),
              ),
            ]),
            if (_userPosition == null) ...[
              const SizedBox(height: 4),
              const Text('Tap "Enable Location" to find events near you', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
            ],
            const SizedBox(height: 14),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _placeholderEvents.length,
                itemBuilder: (context, index) => _EventCard(event: _placeholderEvents[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppPosts() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'For You',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Tips & Updates',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...List.generate(_appPosts.length, (i) => _PostCard(post: _appPosts[i])),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/search-history'),
                  child: const Text('See All', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _dbService.searchHistoryStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const _EmptyHistoryPlaceholder();
                }
                final docs = snapshot.data!.docs;
                final count = docs.length > 3 ? 3 : docs.length;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: count,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.border,
                      indent: 56,
                    ),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.history, color: AppColors.primary, size: 18),
                        ),
                        title: Text(
                          data['query'] ?? '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.north_west_rounded, size: 16, color: AppColors.textGray),
                        onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: data['query']),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: item.label),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: item.color.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(item.icon, color: item.color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final VoidCallback onTap;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGray),
                ),
              ],
            ),
          ),
        ),
      );
}

class _PostCard extends StatelessWidget {
  final _AppPost post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: post.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(post.icon, color: post.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: post.tagColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        post.tag,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: post.tagColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  post.body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryPlaceholder extends StatelessWidget {
  const _EmptyHistoryPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
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

class _BannerItem {
  final String title, subtitle, route, routeArg;
  final IconData icon;
  final List<Color> gradientColors;
  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.route,
    required this.routeArg,
  });
}

class _AppPost {
  final IconData icon;
  final Color color;
  final String tag, title, body;
  final Color tagColor;
  const _AppPost({
    required this.icon,
    required this.color,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.body,
  });
}

class _EventItem {
  final String title, location, date;
  final IconData icon;
  final Color color;
  const _EventItem({required this.title, required this.location, required this.date, required this.icon, required this.color});
}

class _EventCard extends StatelessWidget {
  final _EventItem event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: event.color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(event.icon, color: event.color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(children: [
            Icon(Icons.location_on_rounded, size: 10, color: AppColors.textGray),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                event.location,
                style: const TextStyle(fontSize: 11, color: AppColors.textGray),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.date,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: event.color),
            ),
          ),
        ],
      ),
    );
  }
}
