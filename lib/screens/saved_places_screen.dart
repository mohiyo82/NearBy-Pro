import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class SavedPlacesScreen extends StatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  State<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends State<SavedPlacesScreen> {
  String _selectedFilter = 'All';
  final DatabaseService _dbService = DatabaseService();
  final List<String> _filters = ['All', 'Tech', 'Healthcare', 'Education', 'Finance'];

  @override
  Widget build(BuildContext context) {
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

          // ─── StreamBuilder for Saved Places ───
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _dbService.savedPlacesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                var allPlaces = snapshot.data!.docs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                }).toList();

                var filteredPlaces = _selectedFilter == 'All'
                    ? allPlaces
                    : allPlaces.where((p) => p['cat'] == _selectedFilter).toList();

                if (filteredPlaces.isEmpty) return _buildEmptyState();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, i) {
                    final p = filteredPlaces[i];
                    return _buildPlaceCard(p);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> p) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/result-detail', arguments: p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(_getIconData(p['cat']), color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name'] ?? 'No Name', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(p['cat'] ?? 'General', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Expanded(child: Text('${p['dist'] ?? "0 km"} • ${p['city'] ?? ""}', style: const TextStyle(fontSize: 12, color: AppColors.textGray), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _dbService.toggleSavePlace(p),
                    icon: const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Colors.orange),
                        Text(p['rating']?.toString() ?? "0.0", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 64, color: AppColors.textLight.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('No saved places in $_selectedFilter', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textGray)),
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
