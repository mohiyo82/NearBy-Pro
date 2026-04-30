import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SingleResultCardDetailScreen extends StatelessWidget {
  const SingleResultCardDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive job/place data from arguments
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(body: Center(child: Text("Data not found")));
    }
    final Map<String, dynamic> data = args;

    // Priority: 1. Job/Post specific image, 2. Company Logo, 3. Default Icon
    final String? displayImage = data['imageUrl'] ?? data['jobImage'] ?? data['companyLogo'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF1B4332),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF1B4332).withOpacity(0.1),
                child: (displayImage != null && displayImage.isNotEmpty)
                  ? Image.network(
                      displayImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.business_rounded, size: 80, color: Color(0xFF1B4332)),
                    )
                  : const Icon(Icons.business_rounded, size: 80, color: Color(0xFF1B4332)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? data['name'] ?? 'Detail',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textDark),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data['companyName'] ?? 'Verified Company',
                              style: const TextStyle(fontSize: 16, color: Color(0xFF1B4332), fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Text('ACTIVE', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _featureIcon(Icons.location_on_outlined, data['location'] ?? 'Location'),
                      const SizedBox(width: 16),
                      _featureIcon(Icons.work_outline, data['jobType'] ?? 'Full-time'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Job Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  Text(
                    data['description'] ?? 'No description provided.',
                    style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  if (data['salary'] != null && data['salary'].toString().isNotEmpty) ...[
                    const Text('Salary Package', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Text(data['salary'].toString(), style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 32),
                  ],
                  const Text('About the Company', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  const Text('Join a leading team of professionals dedicated to innovation and excellence.', style: TextStyle(color: AppColors.textGray)),
                  const SizedBox(height: 120), // Bottom padding for bottom sheet
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(color: Color(0xFF1B4332)),
                ),
                child: const Text('Go Back', style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/apply-connect', arguments: data),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4332),
                  minimumSize: const Size(0, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text('Apply for this Job', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureIcon(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            )
          ),
        ],
      ),
    );
  }
}
