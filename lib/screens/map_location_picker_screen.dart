import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({super.key});

  @override
  State<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(31.5204, 74.3587); // Default Lahore
  String _currentAddress = "Fetching your location...";
  bool _isLoading = true;
  
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() => _isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError("Location permissions are denied.");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng latLng = LatLng(position.latitude, position.longitude);
    
    setState(() {
      _currentPosition = latLng;
      _isLoading = false;
    });
    
    _mapController.move(latLng, 15.0);
    _getAddressFromOSM(latLng);
  }

  Future<void> _getAddressFromOSM(LatLng position) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'NearbyProApp/1.0',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _currentAddress = data['display_name'] ?? "Unknown Location";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
      });
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': 'NearbyProApp/1.0',
      });

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _searchResults = data.map((item) => {
            'name': item['display_name'] ?? '',
            'lat': double.parse(item['lat']),
            'lon': double.parse(item['lon']),
          }).toList();
          _showSearchResults = true;
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    LatLng location = LatLng(result['lat'], result['lon']);
    setState(() {
      _currentPosition = location;
      _showSearchResults = false;
      _searchController.text = result['name'].toString().split(',').first;
    });
    _mapController.move(location, 15.0);
    _getAddressFromOSM(location);
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
      _currentAddress = message;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _searchPlaces(value);
            },
            decoration: const InputDecoration(
              hintText: 'Search location...',
              hintStyle: TextStyle(color: AppColors.textGray, fontSize: 14),
              border: InputBorder.none,
              icon: Icon(Icons.search_rounded, color: AppColors.textGray, size: 20),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 15.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && position.center != null) {
                  _currentPosition = position.center!;
                }
              },
              onMapEvent: (event) {
                if (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd) {
                  setState(() {});
                  _getAddressFromOSM(_currentPosition);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.nearby_pro',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition,
                    width: 80,
                    height: 80,
                    child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 48),
                  ),
                ],
              ),
            ],
          ),
          
          if (_showSearchResults && _searchResults.isNotEmpty)
            Positioned(
              top: kToolbarHeight + 40,
              left: 15,
              right: 15,
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      title: Text(result['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                      onTap: () => _selectSearchResult(result),
                    );
                  },
                ),
              ),
            ),

          // Center Indicator (Static)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.textDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Move map to set location', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 52),
              ],
            ),
          ),

          // Bottom Location Card
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Selected Location', style: TextStyle(fontSize: 13, color: AppColors.textGray, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text(_currentAddress, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        Navigator.pop(context, {
                          'position': _currentPosition,
                          'address': _currentAddress,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Confirm Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 200, right: 20,
            child: FloatingActionButton(
              heroTag: 'my_location',
              onPressed: _determinePosition,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location_rounded, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
