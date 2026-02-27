import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultsListViewScreen extends StatefulWidget {
  const ResultsListViewScreen({super.key});

  @override
  State<ResultsListViewScreen> createState() => _ResultsListViewScreenState();
}

class _ResultsListViewScreenState extends State<ResultsListViewScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _mockResults = [
    {
      'name': 'DevTech Solutions',
      'category': 'Software House',
      'location': 'Gulberg III, Lahore',
      'distance': '1.2 km',
      'rating': 4.8,
      'reviews': 124,
      'isHiring': true,
      'isSaved': false,
    },
    {
      'name': 'CloudStream Systems',
      'category': 'IT Company',
      'location': 'DHA Phase 5, Lahore',
      'distance': '3.5 km',
      'rating': 4.5,
      'reviews': 89,
      'isHiring': false,
      'isSaved': true,
    },
    {
      'name': 'AppNexus Labs',
      'category': 'Software House',
      'location': 'Johar Town, Lahore',
      'distance': '5.0 km',
      'rating': 4.2,
      'reviews': 56,
      'isHiring': true,
      'isSaved': false,
    },
    {
      'name': 'ByteWise Technologies',
      'category': 'Tech Agency',
      'location': 'Model Town, Lahore',
      'distance': '0.8 km',
      'rating': 4.9,
      'reviews': 210,
      'isHiring': true,
      'isSaved': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Software Houses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Lahore • 25km • 4 results', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            onPressed: () => Navigator.pushNamed(context, '/results-map'),
            tooltip: 'Map View',
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => Navigator.pushNamed(context, '/advanced-filters'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Open Now', 'Hiring', 'Rated 4+', 'Nearby']
                          .map((f) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedFilter = f),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: _selectedFilter == f ? AppColors.primary : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: _selectedFilter == f ? AppColors.primary : AppColors.border),
                                    ),
                                    child: Text(
                                      f,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _selectedFilter == f ? Colors.white : AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.sort_rounded, size: 20, color: AppColors.textGray),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockResults.length,
              itemBuilder: (context, i) {
                final data = _mockResults[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ResultCard(
                    data: data,
                    onToggleSave: () {
                      setState(() {
                        _mockResults[i]['isSaved'] = !_mockResults[i]['isSaved'];
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onToggleSave;

  const _ResultCard({required this.data, required this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/result-detail'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppColors.primary.withOpacity(0.08),
                child: const Icon(Icons.business_rounded, size: 56, color: AppColors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['name'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          data['isSaved'] ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: data['isSaved'] ? AppColors.primary : AppColors.textGray,
                        ),
                        onPressed: onToggleSave,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['category'],
                    style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGray),
                    const SizedBox(width: 4),
                    Text(data['location'], style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                    const SizedBox(width: 12),
                    const Icon(Icons.directions_walk_rounded, size: 14, color: AppColors.textGray),
                    const SizedBox(width: 4),
                    Text(data['distance'], style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    ...List.generate(5, (s) => Icon(Icons.star_rounded, size: 14, color: s < data['rating'].floor() ? AppColors.warning : AppColors.border)),
                    const SizedBox(width: 6),
                    Text('${data['rating']} (${data['reviews']} reviews)', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                    const Spacer(),
                    if (data['isHiring'])
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Hiring', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
                      ),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/contact-info'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.phone_outlined, size: 16, color: AppColors.primary),
                        label: const Text('Contact', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/apply-connect'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Apply', style: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
