import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _allPlaces = [
    {
      'name': 'Arfa Software Technology Park',
      'cat': 'Tech',
      'icon': Icons.computer_rounded,
      'dist': '3.2 km',
      'rating': '4.5',
      'city': 'Lahore',
      'address': 'Ferozepur Road, Lahore',
    },
    {
      'name': 'Shaukat Khanum Hospital',
      'cat': 'Healthcare',
      'icon': Icons.local_hospital_rounded,
      'dist': '5.8 km',
      'rating': '4.8',
      'city': 'Lahore',
      'address': 'Johar Town, Lahore',
    },
    {
      'name': 'LUMS University',
      'cat': 'Education',
      'icon': Icons.school_rounded,
      'dist': '7.1 km',
      'rating': '4.7',
      'city': 'Lahore',
      'address': 'DHA Phase 5, Lahore',
    },
    {
      'name': 'Habib Bank Plaza',
      'cat': 'Finance',
      'icon': Icons.account_balance_rounded,
      'dist': '1.4 km',
      'rating': '4.2',
      'city': 'Karachi',
      'address': 'I.I. Chundrigar Road, Karachi',
    },
    {
      'name': 'Punjab University',
      'cat': 'Education',
      'icon': Icons.school_outlined,
      'dist': '4.5 km',
      'rating': '4.3',
      'city': 'Lahore',
      'address': 'Canal Road, Lahore',
    },
    {
      'name': 'Tech Valley',
      'cat': 'Tech',
      'icon': Icons.code_rounded,
      'dist': '2.1 km',
      'rating': '4.6',
      'city': 'Abbottabad',
      'address': 'Main Manshera Road',
    },
  ];

  final List<String> _filters = ['All', 'Tech', 'Healthcare', 'Education', 'Finance'];

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _selectedFilter == 'All'
        ? _allPlaces
        : _allPlaces.where((p) => p['cat'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Saved Places'),
        actions: [
          IconButton(
            onPressed: () => _showSortOptions(),
            icon: const Icon(Icons.filter_list_rounded),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/results-map'),
            icon: const Icon(Icons.map_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Filter Bar ───
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: _filters.map((f) {
                final isSelected = _selectedFilter == f;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                          : null,
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredPlaces.length} places found',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textGray),
                ),
                TextButton.icon(
                  onPressed: () => _showSortOptions(),
                  icon: const Icon(Icons.sort_rounded, size: 16),
                  label: const Text('Sort', style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
          ),

          // ─── Places List ───
          Expanded(
            child: filteredPlaces.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, i) {
                      final p = filteredPlaces[i];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/result-detail',
                          arguments: p,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(p['icon'] as IconData, color: AppColors.primary, size: 28),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['name'] as String,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p['cat'] as String,
                                        style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${p['dist']} • ${p['city']}',
                                              style: const TextStyle(fontSize: 12, color: AppColors.textGray),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Removed from saved places')),
                                        );
                                      },
                                      icon: const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 22),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 14, color: Colors.orange),
                                          Text(
                                            p['rating'] as String,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 64, color: AppColors.textLight.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No saved places in $_selectedFilter',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textGray),
          ),
          const SizedBox(height: 8),
          const Text('Save places to see them here', style: TextStyle(color: AppColors.textLight)),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSortItem('Distance (Nearest first)', true),
            _buildSortItem('Rating (Highest first)', false),
            _buildSortItem('Name (A-Z)', false),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSortItem(String title, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(color: isSelected ? AppColors.primary : AppColors.textDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
      onTap: () => Navigator.pop(context),
    );
  }
}
