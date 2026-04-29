import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
  Timer? _autoPopupTimer;

  static const List<String> _popularSearches = [
    'Hospitals near me', 'Software Houses', 'Best Restaurants', 'Schools', 'Banks', 'Hotels', 'Jobs', 'Factories',
  ];

  static const List<_CategoryItem> _categories = [
    _CategoryItem('Hospitals', Icons.local_hospital_rounded, Color(0xFFE53935), Color(0xFFFF8A80)),
    _CategoryItem('Schools', Icons.school_rounded, Color(0xFFF57C00), Color(0xFFFFCC02)),
    _CategoryItem('Software Houses', Icons.code_rounded, Color(0xFF1565C0), Color(0xFF42A5F5)),
    _CategoryItem('Factories', Icons.precision_manufacturing_rounded, Color(0xFF546E7A), Color(0xFF90A4AE)),
    _CategoryItem('Banks', Icons.account_balance_rounded, Color(0xFF2E7D32), Color(0xFF66BB6A)),
    _CategoryItem('Hotels', Icons.hotel_rounded, Color(0xFF6A1B9A), Color(0xFFCE93D8)),
    _CategoryItem('Restaurants', Icons.restaurant_rounded, Color(0xFFBF360C), Color(0xFFFF7043)),
    _CategoryItem('More', Icons.grid_view_rounded, Color(0xFF37474F), Color(0xFF78909C)),
  ];

  static const List<_BannerItem> _banners = [
    _BannerItem(title: 'Explore Jobs', subtitle: 'Thousands of opportunities', icon: Icons.work_rounded, gradientColors: [AppColors.primary, AppColors.primaryLight], route: '/search-loading', routeArg: 'Jobs'),
    _BannerItem(title: 'Find Top Hospitals', subtitle: 'Verified medical centers', icon: Icons.local_hospital_rounded, gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)], route: '/search-loading', routeArg: 'Hospitals'),
    _BannerItem(title: 'Best Schools', subtitle: 'Top-rated education', icon: Icons.school_rounded, gradientColors: [Color(0xFFF57C00), Color(0xFFFFCA28)], route: '/search-loading', routeArg: 'Schools'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _startAutoPopupTimer();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _autoPopupTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      if (mounted) setState(() => _userPosition = position);
    } catch (_) {}
  }

  void _startAutoPopupTimer() {
    _autoPopupTimer = Timer(const Duration(seconds: 1), () async {
      final user = _authService.currentUser;
      if (user != null && mounted) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && (doc.data()?['activePlan'] ?? 'free') == 'free') {
          _showLevelUpPopup();
        }
      }
    });
  }

  void _showLevelUpPopup() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)], begin: Alignment.topCenter), borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.rocket_launch_rounded, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text('Level Up Your Career!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Upgrade to Pro for unlimited job matches and priority applications.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () { Navigator.pop(ctx); Navigator.pushNamed(context, '/subscriptions'); },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text('Upgrade Today', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No Thanks', style: TextStyle(color: Colors.white60))),
            ],
          ),
        ),
      ),
    );
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
            bool isPro = false;
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              userName = data['firstName'] ?? data['name'] ?? "User";
              photoUrl = data['photoUrl'];
              isPro = data['isPro'] ?? false;
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(userName, photoUrl, isPro),
                const SliverToBoxAdapter(child: SizedBox(height: 22)),
                _buildQuickStats(),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                _buildBannerSlider(),
                _buildSmartSuggestions(),
                _buildCategories(),
                _buildRecentSearches(),
                
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 14),
                    child: Row(children: [Text('Explore Feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark)), SizedBox(width: 8), Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20)]),
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const SliverToBoxAdapter(child: Center(child: Text('Error loading feed.')));
                    if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                    
                    final posts = snapshot.data!.docs.toList();
                    posts.sort((a, b) {
                      final t1 = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
                      final t2 = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
                      return t2.compareTo(t1);
                    });

                    if (posts.isEmpty) return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(40), child: Center(child: Text('No posts yet.'))));

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildEnhancedPostCard(posts[index].id, posts[index].data() as Map<String, dynamic>),
                        childCount: posts.length,
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-post'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEnhancedPostCard(String postId, Map<String, dynamic> post) {
    final timestamp = post['timestamp'] as Timestamp?;
    final timeStr = timestamp != null ? DateFormat('MMM d, h:mm a').format(timestamp.toDate()) : 'Recently';
    final List<dynamic> likedBy = post['likedBy'] ?? [];
    final bool isLiked = likedBy.contains(_authService.currentUser?.uid);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/company-profile', arguments: post['authorId']),
                child: CircleAvatar(
                  radius: 20, backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: (post['authorLogo'] != null && post['authorLogo'].isNotEmpty) ? NetworkImage(post['authorLogo']) : null,
                  child: (post['authorLogo'] == null || post['authorLogo'].isEmpty) ? const Icon(Icons.person, size: 20, color: AppColors.primary) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  GestureDetector(onTap: () => Navigator.pushNamed(context, '/company-profile', arguments: post['authorId']), child: Text(post['authorName'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  Text(timeStr, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                ]),
              ),
              // --- Follow Button on the Right ---
              if (post['authorType'] == 'company' && post['authorId'] != _authService.currentUser?.uid)
                _buildFollowButton(post['authorId']),
            ],
          ),
          const SizedBox(height: 14),
          _ExpandableText(text: post['content'] ?? ''),
          if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty) ...[
            const SizedBox(height: 14),
            ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(post['imageUrl'], width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _postAction(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, '${post['likes'] ?? 0}', isLiked ? Colors.red : AppColors.textGray, () => _dbService.toggleLike(postId, isLiked)),
              const SizedBox(width: 24),
              _postAction(Icons.chat_bubble_outline_rounded, '${post['comments'] ?? 0}', AppColors.textGray, () => _showCommentsBottomSheet(postId)),
              const Spacer(),
              if (post['type'] == 'job')
                TextButton(onPressed: () => Navigator.pushNamed(context, '/result-detail', arguments: post), child: const Text('View Job', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton(String authorId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_authService.currentUser?.uid).collection('following').doc(authorId).snapshots(),
      builder: (context, snapshot) {
        bool isFollowing = snapshot.hasData && snapshot.data!.exists;
        return TextButton(
          onPressed: () => _dbService.toggleFollow(authorId, isFollowing),
          style: TextButton.styleFrom(
            backgroundColor: isFollowing ? Colors.grey[200] : AppColors.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            minimumSize: const Size(60, 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            isFollowing ? 'Following' : 'Follow', 
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.bold, 
              color: isFollowing ? Colors.grey[700] : AppColors.primary
            )
          ),
        );
      },
    );
  }

  void _showCommentsBottomSheet(String postId) {
    final commentC = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.white, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7, padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final comments = snapshot.data!.docs;
                  if (comments.isEmpty) return const Center(child: Text('No comments yet.', style: TextStyle(color: Colors.grey)));
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final c = comments[index].data() as Map<String, dynamic>;
                      return ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(radius: 16, backgroundImage: (c['userPhoto'] != null && c['userPhoto'].isNotEmpty) ? NetworkImage(c['userPhoto']) : null, child: (c['userPhoto'] == null || c['userPhoto'].isEmpty) ? const Icon(Icons.person, size: 16) : null), title: Text(c['userName'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), subtitle: Text(c['text'] ?? '', style: const TextStyle(color: Colors.black87)));
                    },
                  );
                },
              ),
            ),
            Row(children: [
              Expanded(child: TextField(controller: commentC, decoration: InputDecoration(hintText: 'Add a comment...', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)))),
              const SizedBox(width: 8),
              IconButton(onPressed: () async { if (commentC.text.trim().isNotEmpty) { await _dbService.addComment(postId, commentC.text); commentC.clear(); } }, icon: const Icon(Icons.send_rounded, color: AppColors.primary)),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _postAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Row(children: [Icon(icon, size: 20, color: color), const SizedBox(width: 6), Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600))]));
  }

  Widget _buildHeader(String userName, String? photoUrl, bool isPro) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Stack(alignment: Alignment.bottomRight, children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle, image: (photoUrl != null && photoUrl.isNotEmpty) ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover) : null), child: (photoUrl == null || photoUrl.isEmpty) ? Center(child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))) : null),
              if (isPro) Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle), child: const Icon(Icons.verified_rounded, color: Colors.white, size: 10)),
            ]),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Hello, $userName! 👋', style: const TextStyle(fontSize: 13, color: Colors.white70)), const Text('Find Places Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))]),
            const Spacer(),
            if (isPro) Container(margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withValues(alpha: 0.5))), child: const Text('PRO', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2))),
            GestureDetector(onTap: () => Navigator.pushNamed(context, '/notification-settings'), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.notifications_outlined, color: Colors.white))),
          ]),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ]),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/global-search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))]),
        child: const Row(children: [Icon(Icons.search_rounded, color: AppColors.textGray), SizedBox(width: 10), Expanded(child: Text('Search hospitals, jobs, schools...', style: TextStyle(color: AppColors.textLight, fontSize: 14))), Icon(Icons.tune_rounded, color: AppColors.primary, size: 20)]),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Quick Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 14),
          Row(children: [
            _buildStatItem('search_history', 'Searches', Icons.search_rounded, AppColors.primary, '/search-history'),
            const SizedBox(width: 12),
            _buildStatItem('saved_places', 'Saved', Icons.bookmark_rounded, AppColors.secondary, '/saved-places'),
            const SizedBox(width: 12),
            _buildStatItem('applications', 'Applied', Icons.send_rounded, AppColors.accent, '/contact-list'),
          ]),
        ]),
      ),
    );
  }

  Widget _buildStatItem(String collection, String label, IconData icon, Color color, String route) {
    return StreamBuilder<int>(
      stream: _dbService.getCollectionCount(collection),
      builder: (context, snapshot) => _StatCard(icon: icon, label: label, value: (snapshot.data ?? 0).toString(), color: color, onTap: () => Navigator.pushNamed(context, route)),
    );
  }

  Widget _buildBannerSlider() {
    return SliverToBoxAdapter(
      child: Column(children: [
        SizedBox(height: 150, child: PageView.builder(controller: _bannerController, itemCount: _banners.length, onPageChanged: (i) => setState(() => _currentBanner = i), itemBuilder: (context, index) {
          final b = _banners[index];
          return GestureDetector(onTap: () => Navigator.pushNamed(context, b.route, arguments: b.routeArg), child: Container(margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(gradient: LinearGradient(colors: b.gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: b.gradientColors.last.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))]), child: Stack(children: [Positioned(right: -20, top: -20, child: Container(width: 130, height: 130, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle))), Padding(padding: const EdgeInsets.all(20), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20)), child: const Text('EXPLORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2))), const SizedBox(height: 8), Text(b.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)), const SizedBox(height: 4), Text(b.subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)))])) , Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: Icon(b.icon, color: Colors.white, size: 28))]))])));
        })),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_banners.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 3), width: _currentBanner == i ? 24 : 8, height: 8, decoration: BoxDecoration(color: _currentBanner == i ? AppColors.primary : AppColors.border, borderRadius: BorderRadius.circular(4))))),
      ]),
    );
  }

  Widget _buildSmartSuggestions() {
    return SliverToBoxAdapter(
      child: StreamBuilder<QuerySnapshot>(
        stream: _dbService.searchHistoryStream,
        builder: (context, snapshot) {
          final List<String> suggestions = [];
          if (snapshot.hasData) { for (final doc in snapshot.data!.docs.take(3)) { final q = (doc.data() as Map<String, dynamic>)['query'] ?? ''; if (q.isNotEmpty) suggestions.add(q); } }
          for (final p in _popularSearches) { if (!suggestions.contains(p) && suggestions.length < 6) suggestions.add(p); }
          if (suggestions.isEmpty) return const SizedBox.shrink();
          return Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary), SizedBox(width: 6), Text('Smart Suggestions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark))]), const SizedBox(height: 12), Wrap(spacing: 8, runSpacing: 8, children: suggestions.map((s) => GestureDetector(onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: s), child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.textGray), const SizedBox(width: 6), Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark))])))).toList())]));
        },
      ),
    );
  }

  Widget _buildCategories() {
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text('Browse by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)), const Spacer(), TextButton(onPressed: () => Navigator.pushNamed(context, '/category-selection'), child: const Text('See All', style: TextStyle(color: AppColors.primary)))]), const SizedBox(height: 14), GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 16, childAspectRatio: 0.80), itemCount: _categories.length, itemBuilder: (context, index) => _CategoryCard(item: _categories[index]))])),
    );
  }

  Widget _buildRecentSearches() {
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)), const Spacer(), TextButton(onPressed: () => Navigator.pushNamed(context, '/search-history'), child: const Text('See All', style: TextStyle(color: AppColors.primary, fontSize: 13)))]), const SizedBox(height: 10), StreamBuilder<QuerySnapshot>(stream: _dbService.searchHistoryStream, builder: (context, snapshot) { if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const _EmptyHistoryPlaceholder(); final docs = snapshot.data!.docs; final count = docs.length > 3 ? 3 : docs.length; return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: count, separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border, indent: 56), itemBuilder: (context, index) { final data = docs[index].data() as Map<String, dynamic>; return ListTile(leading: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.history, color: AppColors.primary, size: 18)), title: Text(data['query'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), trailing: const Icon(Icons.north_west_rounded, size: 16, color: AppColors.textGray), onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: data['query'])); })); })])),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const _ExpandableText({required this.text, this.maxLines = 3});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: isExpanded ? null : widget.maxLines,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.5),
            ),
            if (!isExpanded && widget.text.length > 100) 
              GestureDetector(
                onTap: () => setState(() => isExpanded = true),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Read more',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: item.label), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 60, height: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [item.color, item.colorLight], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: item.color.withValues(alpha: 0.30), blurRadius: 12, offset: const Offset(0, 5))]), child: Stack(alignment: Alignment.center, children: [Positioned(top: 6, left: 6, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), shape: BoxShape.circle))), Icon(item.icon, color: Colors.white, size: 26)])), const SizedBox(height: 8), Text(item.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis)]));
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final VoidCallback onTap;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18),), const SizedBox(height: 10), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)), Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray))]))));
}

class _EmptyHistoryPlaceholder extends StatelessWidget {
  const _EmptyHistoryPlaceholder();
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: const Column(children: [Icon(Icons.history_rounded, size: 44, color: AppColors.textLight), SizedBox(height: 10), Text('No recent searches', style: TextStyle(fontSize: 14, color: AppColors.textGray))]));
}

class _CategoryItem {
  final String label; final IconData icon; final Color color; final Color colorLight;
  const _CategoryItem(this.label, this.icon, this.color, this.colorLight);
}

class _BannerItem {
  final String title, subtitle, route, routeArg; final IconData icon; final List<Color> gradientColors;
  const _BannerItem({required this.title, required this.subtitle, required this.icon, required this.gradientColors, required this.route, required this.routeArg});
}
