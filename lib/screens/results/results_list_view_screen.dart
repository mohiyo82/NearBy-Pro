import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class ResultsListViewScreen extends StatefulWidget {
  const ResultsListViewScreen({super.key});

  @override
  State<ResultsListViewScreen> createState() => _ResultsListViewScreenState();
}

class _ResultsListViewScreenState extends State<ResultsListViewScreen> {
  String _query = '';
  double _radius = 25.0;
  Position? _currentPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      _query = args['query'] ?? '';
      _radius = (args['radius'] ?? 25.0).toDouble();
    } else if (args is String) {
      _query = args;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  double _calculateDistance(double? lat, double? lon) {
    if (_currentPosition == null || lat == null || lon == null) return 0.0;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lon,
    ) / 1000; // to km
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_query.isEmpty ? 'Job Results' : _query, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Radius: ${_radius.round()}km', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobs').where('status', isEqualTo: 'active').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading jobs.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final jobs = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

          final filteredJobs = jobs.where((job) {
            final title = (job['title'] ?? '').toString().toLowerCase();
            final company = (job['companyName'] ?? '').toString().toLowerCase();
            final searchLower = _query.toLowerCase();
            bool matchesQuery = title.contains(searchLower) || company.contains(searchLower);
            double dist = _calculateDistance(job['latitude'], job['longitude']);
            bool withinRange = dist <= _radius || job['latitude'] == null;
            return matchesQuery && withinRange;
          }).toList();

          if (filteredJobs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No live jobs found for this search.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredJobs.length,
            itemBuilder: (context, i) {
              final job = filteredJobs[i];
              return _ProfessionalJobCard(
                job: job,
                onTap: () => Navigator.pushNamed(context, '/result-detail', arguments: job),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfessionalJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onTap;

  const _ProfessionalJobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
          border: Border.all(color: AppColors.border.withOpacity(0.8)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08), 
                      borderRadius: BorderRadius.circular(14),
                      image: (job['companyLogo'] != null && job['companyLogo'].isNotEmpty)
                        ? DecorationImage(image: NetworkImage(job['companyLogo']), fit: BoxFit.cover)
                        : null,
                    ),
                    child: (job['companyLogo'] == null || job['companyLogo'].isEmpty)
                      ? const Icon(Icons.business_rounded, color: AppColors.primary, size: 28)
                      : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job['title'] ?? 'Role', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                        const SizedBox(height: 2),
                        Text(job['companyName'] ?? 'Company', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  // Wrap location text to prevent overflow
                  Expanded(
                    child: Text(
                      job['location'] ?? 'Location', 
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(job['jobType'] ?? 'Full-time', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
