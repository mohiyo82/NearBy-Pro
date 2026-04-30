import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class ManageApplicantsScreen extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const ManageApplicantsScreen({super.key, required this.jobId, required this.jobTitle});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Applicants: $jobTitle', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .doc(jobId)
            .collection('applicants')
            .orderBy('appliedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final applicants = snapshot.data!.docs;
          if (applicants.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No applicants yet.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applicants.length,
            itemBuilder: (context, i) {
              final app = applicants[i].data() as Map<String, dynamic>;
              final time = app['appliedAt'] != null ? DateFormat('MMM d, h:mm a').format((app['appliedAt'] as Timestamp).toDate()) : '';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: (app['applicantPhoto'] != null && app['applicantPhoto'].isNotEmpty)
                              ? NetworkImage(app['applicantPhoto'])
                              : null,
                          child: (app['applicantPhoto'] == null || app['applicantPhoto'].isEmpty)
                              ? const Icon(Icons.person, color: AppColors.primary, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(app['applicantName'] ?? 'Candidate', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textDark)),
                              const SizedBox(height: 2),
                              Text('Applied on $time', style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
                              const SizedBox(height: 8),
                              _statusBadge(app['status'] ?? 'pending'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    
                    const Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.email_outlined, app['applicantEmail'] ?? 'N/A'),
                    _buildInfoRow(Icons.phone_outlined, app['applicantPhone'] ?? 'N/A'),
                    if (app['portfolioUrl'] != null && app['portfolioUrl'].isNotEmpty)
                      _buildInfoRow(Icons.link_rounded, app['portfolioUrl'], isLink: true),

                    const SizedBox(height: 20),
                    const Text('Resume / CV', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            app['useGeneratedResume'] == true ? Icons.auto_awesome_rounded : Icons.file_present_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app['useGeneratedResume'] == true ? 'NearBy Pro AI Resume' : 'Custom Uploaded Resume',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  app['useGeneratedResume'] == true ? 'Generated from profile data' : (app['resumeUrl'] != null ? 'View PDF document' : 'No document link'),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textGray),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Logic to view resume
                            },
                            child: const Text('View CV', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text('Message to Employer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        app['message'] != null && app['message'].isNotEmpty ? app['message'] : 'No message provided.',
                        style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textDark),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => dbService.updateApplicationStatus(jobId, app['applicantUid'], 'rejected'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => dbService.updateApplicationStatus(jobId, app['applicantUid'], 'accepted'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B4332),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: const Text('Accept Candidate', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGray),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isLink ? Colors.blue : AppColors.textGray,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = Colors.orange;
    String label = 'PENDING REVIEW';
    if (status == 'accepted') {
      color = Colors.green;
      label = 'ACCEPTED';
    }
    if (status == 'rejected') {
      color = Colors.red;
      label = 'REJECTED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }
}
