import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class JobsDiscoveryScreen extends StatefulWidget {
  const JobsDiscoveryScreen({super.key});

  @override
  State<JobsDiscoveryScreen> createState() => _JobsDiscoveryScreenState();
}

class _JobsDiscoveryScreenState extends State<JobsDiscoveryScreen> {
  final List<Map<String, dynamic>> _jobs = [
    {
      'company': 'Systems Ltd',
      'role': 'Flutter Developer',
      'area': 'Gulberg, Lahore',
      'dist': '2.5 km',
      'source': 'LinkedIn',
      'tags': ['Remote', 'Full-time'],
      'logo': Icons.computer_rounded,
    },
    {
      'company': 'Shaukat Khanum',
      'role': 'Data Analyst',
      'area': 'Johar Town, Lahore',
      'dist': '5.8 km',
      'source': 'Official Website',
      'tags': ['On-site', 'Contract'],
      'logo': Icons.local_hospital_rounded,
    },
    {
      'company': 'Devsinc',
      'role': 'UI/UX Designer',
      'area': 'DHA Phase 6, Lahore',
      'dist': '8.1 km',
      'source': 'Facebook',
      'tags': ['Internship', 'Hiring'],
      'logo': Icons.design_services_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Jobs Near You'),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/advanced-filters'), icon: const Icon(Icons.tune_rounded)),
        ],
      ),
      body: Column(
        children: [
          _buildAreaHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _jobs.length,
              itemBuilder: (context, i) => _buildJobCard(_jobs[i]),
            ),
          ),
          const SizedBox(height: 80), // For nav bar
        ],
      ),
    );
  }

  Widget _buildAreaHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.radar_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Area: Lahore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Radius: 10km • 25 Jobs Found', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
            ],
          ),
          const Spacer(),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/distance-filter'), child: const Text('Change Radius')),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(job['logo'], color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['role'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    Text(job['company'], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border_rounded, color: AppColors.textLight),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGray),
              const SizedBox(width: 4),
              Text('${job['area']} (${job['dist']})', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('Source: ${job['source']}', style: const TextStyle(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              ...job['tags'].map<Widget>((t) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text('#$t', style: const TextStyle(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500)),
              )).toList(),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/apply-connect'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(80, 36), padding: const EdgeInsets.symmetric(horizontal: 16)),
                child: const Text('View & Apply', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
