import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  int _currentIndex = 1;

  static const List<String> _suggestions = [
    'Software House', 'Hospital', 'School', 'Bank', 'Factory',
    'Restaurant', 'Hotel', 'Pharmacy', 'Clinic', 'University',
  ];

  static const List<String> _trending = [
    'IT Companies in Lahore', 'Hospitals near me', 'Jobs in Karachi',
    'Software House Islamabad', 'Private Schools',
  ];

  void _performSearch([String? query]) {
    final searchTerm = query ?? _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      setState(() {
        if (!_searchHistory.contains(searchTerm)) {
          _searchHistory.insert(0, searchTerm);
        }
      });
      // Navigate to results
      Navigator.pushNamed(context, '/search-loading');
    }
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _onBottomNavTapped(int index) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/saved-places');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/profile-preview');
          break;
      }
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onSubmitted: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search places, companies, jobs...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGray),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textGray),
                  onPressed: _clearSearch,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Popular Categories', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestions.map((s) => GestureDetector(
                onTap: () => _performSearch(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 28),
            const Row(
              children: [
                Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('Trending Searches', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              ],
            ),
            const SizedBox(height: 12),
            ..._trending.map((t) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 18),
              ),
              title: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
              trailing: const Icon(Icons.north_west_rounded, size: 16, color: AppColors.textLight),
              onTap: () => _performSearch(t),
            )),
            const SizedBox(height: 24),
            const Text('Search History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),
            _searchHistory.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: const Row(
                      children: [
                        Icon(Icons.history_rounded, color: AppColors.textLight),
                        SizedBox(width: 12),
                        Text('No recent searches', style: TextStyle(color: AppColors.textGray)),
                      ],
                    ),
                  )
                : Column(
                    children: _searchHistory
                        .map((h) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.history_rounded, color: AppColors.textGray),
                              title: Text(h, style: const TextStyle(fontWeight: FontWeight.w500)),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textLight),
                                onPressed: () => setState(() => _searchHistory.remove(h)),
                              ),
                              onTap: () => _performSearch(h),
                            ))
                        .toList(),
                  ),
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
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
