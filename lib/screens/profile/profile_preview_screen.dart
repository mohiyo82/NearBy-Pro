import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class ProfilePreviewScreen extends StatefulWidget {
  const ProfilePreviewScreen({super.key});

  @override
  State<ProfilePreviewScreen> createState() => _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends State<ProfilePreviewScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _isGeneratingPdf = false;

  Future<void> _generateAndDownloadCv(Map<String, dynamic> data) async {
    setState(() => _isGeneratingPdf = true);
    
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('${data['firstName'] ?? ''} ${data['lastName'] ?? ''}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                          pw.Text(data['email'] ?? '', style: const pw.TextStyle(fontSize: 12)),
                          pw.Text(data['phone'] ?? '', style: const pw.TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Professional Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                pw.Text(data['bio'] ?? 'No bio provided.'),
                pw.SizedBox(height: 20),
                pw.Text('Skills', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                pw.Wrap(
                  spacing: 10,
                  children: (data['skills'] as List? ?? []).map((s) => pw.Text('• ${s['name']}')).toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Education', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                ...(data['education'] as List? ?? []).map((e) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(e['degree'] ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(e['institute'] ?? ''),
                    ],
                  ),
                )),
                pw.SizedBox(height: 20),
                pw.Text('Experience', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                ...(data['experience'] as List? ?? []).map((ex) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(ex['role'] ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(ex['company'] ?? ''),
                    ],
                  ),
                )),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('My Professional Profile'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
            icon: const Icon(Icons.edit_note_rounded),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Profile not found. Please create one.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(data),
                const SizedBox(height: 16),
                _buildAboutCard(data['bio']),
                const SizedBox(height: 16),
                _buildSkillsCard(data['skills']),
                const SizedBox(height: 16),
                _buildSectionCard('Education', Icons.school_rounded, data['education']),
                const SizedBox(height: 16),
                _buildSectionCard('Experience', Icons.work_rounded, data['experience']),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: _isGeneratingPdf ? 'Generating CV...' : 'Download Professional CV',
                  icon: Icons.file_download_outlined,
                  onTap: () => _generateAndDownloadCv(data),
                  isLoading: _isGeneratingPdf,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> data) {
    String name = '${data['firstName'] ?? 'User'} ${data['lastName'] ?? ''}';
    String imagePath = data['profileImage'] ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
            child: imagePath.isEmpty ? const Icon(Icons.person, size: 40, color: AppColors.primary) : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(data['email'] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
                Text(data['phone'] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(String? bio) {
    return _BaseCard(
      title: 'About',
      child: Text(
        bio ?? 'No bio added yet.',
        style: const TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.5),
      ),
    );
  }

  Widget _buildSkillsCard(List? skills) {
    return _BaseCard(
      title: 'Skills',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: (skills ?? []).map((s) => Chip(
          label: Text(s['name']),
          backgroundColor: AppColors.primary.withOpacity(0.05),
          labelStyle: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
          padding: EdgeInsets.zero,
        )).toList(),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List? items) {
    return _BaseCard(
      title: title,
      child: (items == null || items.isEmpty)
          ? Text('No $title details added.', style: const TextStyle(color: AppColors.textLight, fontSize: 13))
          : Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 18, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['degree'] ?? item['role'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(item['institute'] ?? item['company'] ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _BaseCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }
}
