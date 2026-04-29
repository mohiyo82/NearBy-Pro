import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_theme.dart';

class ResultsMapViewScreen extends StatefulWidget {
  const ResultsMapViewScreen({super.key});

  @override
  State<ResultsMapViewScreen> createState() => _ResultsMapViewScreenState();
}

class _ResultsMapViewScreenState extends State<ResultsMapViewScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(31.5204, 74.3587);
  double _radius = 25.0;
  String _query = '';
  List<Map<String, dynamic>> _jobsInRange = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      _query = args['query'] ?? '';
      _radius = (args['radius'] ?? 25.0).toDouble();
      _center = args['center'] ?? const LatLng(31.5204, 74.3587);
    }
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('status', isEqualTo: 'active')
          .get();

      final List<Map<String, dynamic>> found = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['latitude'] != null && data['longitude'] != null) {
          double dist = Geolocator.distanceBetween(
            _center.latitude, _center.longitude,
            data['latitude'], data['longitude']
          ) / 1000;

          if (dist <= _radius) {
            data['id'] = doc.id;
            data['distance'] = dist;
            // Also match search query if present
            if (_query.isEmpty ||
                (data['title'] ?? '').toString().toLowerCase().contains(_query.toLowerCase()) ||
                (data['companyName'] ?? '').toString().toLowerCase().contains(_query.toLowerCase())) {
              found.add(data);
            }
          }
        }
      }
      setState(() {
        _jobsInRange = found;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_query.isEmpty ? 'Nearby Jobs' : _query, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${_jobsInRange.length} jobs in ${_radius.round()}km', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'Nearby.pro',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _center,
                    radius: _radius * 1000,
                    useRadiusInMeter: true,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderColor: AppColors.primary.withValues(alpha: 0.3),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // User Center Marker
                  Marker(
                    point: _center,
                    width: 40, height: 40,
                    child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                  ),
                  // Job Markers
                  ..._jobsInRange.map((job) => Marker(
                    point: LatLng(job['latitude'], job['longitude']),
                    width: 50, height: 50,
                    child: GestureDetector(
                      onTap: () => _showJobSnippet(job),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                        child: job['companyLogo'] != null ? ClipOval(child: Image.network(job['companyLogo'])) : const Icon(Icons.work, color: AppColors.primary, size: 20),
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          Positioned(
            bottom: 20, left: 16, right: 16,
            child: _jobsInRange.isEmpty && !_isLoading
              ? const SizedBox.shrink()
              : const SizedBox.shrink(), // Snapshot will be shown via _showJobSnippet
          ),
        ],
      ),
    );
  }

  void _showJobSnippet(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15)]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)), child: job['companyLogo'] != null ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(job['companyLogo'], fit: BoxFit.cover)) : const Icon(Icons.business, color: AppColors.primary)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(job['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text(job['companyName'] ?? '', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))])),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job['location'] ?? '', style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                Text('${job['distance'].toStringAsFixed(1)} km away', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/result-detail', arguments: job),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4332), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('View Full Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
