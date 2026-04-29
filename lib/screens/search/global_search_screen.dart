import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';
import 'distance_filter_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  final MapController _mapController = MapController();
  
  int _currentIndex = 1;
  double _selectedRadius = 25.0; 
  LatLng _searchCenter = const LatLng(31.5204, 74.3587); // Default Lahore
  bool _isLocating = true;

  static const List<String> _popularCategories = [
    'Software House', 'Hospital', 'School', 'Bank', 'Factory',
    'Restaurant', 'Hotel', 'Pharmacy',
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLocating = true);
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _searchCenter = LatLng(position.latitude, position.longitude);
        _isLocating = false;
      });
      _mapController.move(_searchCenter, 12.0);
    } catch (e) {
      setState(() => _isLocating = false);
    }
  }

  void _performSearch([String? query]) async {
    final searchTerm = query ?? _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      await _dbService.addSearchHistory(searchTerm);
      if (mounted) {
        Navigator.pushNamed(
          context, 
          '/search-loading', 
          arguments: {
            'query': searchTerm,
            'radius': _selectedRadius,
            'center': _searchCenter,
          }
        );
      }
    }
  }

  void _openDistancePicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DistanceFilterScreen(initialRadius: _selectedRadius),
      ),
    );

    if (result != null && result is double) {
      setState(() {
        _selectedRadius = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── FULL BACKGROUND MAP ───
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _searchCenter,
              initialZoom: 12.0,
              onTap: (tapPosition, point) {
                setState(() => _searchCenter = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'Nearby.pro',
              ),
              // Radius Circle Visualization
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _searchCenter,
                    radius: _selectedRadius * 1000, // km to meters
                    useRadiusInMeter: true,
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderColor: AppColors.primary,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _searchCenter,
                    width: 60, height: 60,
                    child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // ─── TOP SEARCH BAR OVERLAY ───
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _performSearch(),
                      decoration: InputDecoration(
                        hintText: 'Search jobs, companies...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location_rounded, color: AppColors.primary),
                          onPressed: _getUserLocation,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                
                // Radius Picker Chip
                GestureDetector(
                  onTap: _openDistancePicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B4332),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.radar_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Radius: ${_selectedRadius.round()} km',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── BOTTOM CATEGORIES OVERLAY ───
          Positioned(
            bottom: 100, left: 0, right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _popularCategories.map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(cat),
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onPressed: () => _performSearch(cat),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/home');
          if (i == 2) Navigator.pushReplacementNamed(context, '/saved-places');
          if (i == 3) Navigator.pushReplacementNamed(context, '/settings');
          setState(() => _currentIndex = i);
        },
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
}
