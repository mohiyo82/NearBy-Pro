import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../theme/app_theme.dart';

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
                          pw.Text('${data['firstName'] ?? ''} ${data['lastName'] ?? ''}', 
                              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                          pw.Text(data['title'] ?? '', style: const pw.TextStyle(fontSize: 14)),
                          pw.Text(data['email'] ?? '', style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(data['phone'] ?? '', style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Professional Summary', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                pw.Text(data['bio'] ?? 'No bio provided.', style: const pw.TextStyle(fontSize: 11)),
                
                if ((data['education'] as List? ?? []).isNotEmpty) ...[
                  pw.SizedBox(height: 20),
                  pw.Text('Education', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  ...(data['education'] as List? ?? []).map((e) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(e['degree'] ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                        pw.Text('${e['institution'] ?? ''} | ${e['startDate'] ?? ''} - ${e['endDate'] ?? 'Present'}', 
                            style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                  )),
                ],

                if ((data['experience'] as List? ?? []).isNotEmpty) ...[
                  pw.SizedBox(height: 20),
                  pw.Text('Experience', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(),
                  ...(data['experience'] as List? ?? []).map((ex) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(ex['jobTitle'] ?? '', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                        pw.Text('${ex['companyName'] ?? ''} | ${ex['startDate'] ?? ''} - ${ex['endDate'] ?? 'Present'}', 
                            style: const pw.TextStyle(fontSize: 10)),
                        if (ex['description'] != null)
                          pw.Text(ex['description'], style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                  )),
                ],
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please log in first')));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('My Professional Profile', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1B4332)),
            tooltip: 'Edit Profile',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1B4332)));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Profile not found. Go to Edit to create one.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(data),
                const SizedBox(height: 16),
                _buildAboutCard(data['bio']),
                const SizedBox(height: 16),
                _buildEducationSection(data['education']),
                const SizedBox(height: 16),
                _buildExperienceSection(data['experience']),
                const SizedBox(height: 16),
                _buildCertificateSection(data['certificates']),
                const SizedBox(height: 16),
                _buildLinksSection(data),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isGeneratingPdf ? null : () => _generateAndDownloadCv(data),
                    icon: _isGeneratingPdf 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.file_download_outlined),
                    label: Text(_isGeneratingPdf ? 'Generating CV...' : 'Download Professional CV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4332),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
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
    String name = '${data['firstName'] ?? 'User'} ${data['lastName'] ?? ''}'.trim();
    if (name.isEmpty) name = 'No Name Set';
    String? photoUrl = data['photoUrl'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xFFF3F4F6),
            backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
            child: (photoUrl == null || photoUrl.isEmpty) 
                ? const Icon(Icons.person, size: 42, color: Color(0xFF9CA3AF)) 
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, 
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                Text(data['title'] ?? 'software engineer', 
                  style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 16, color: Color(0xFF6B7280)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(data['email'] ?? user?.email ?? '', 
                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    ),
                  ],
                ),
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
        (bio == null || bio.isEmpty) ? 'No bio added yet.' : bio,
        style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.6),
      ),
    );
  }

  Widget _buildEducationSection(List? items) {
    return _BaseCard(
      title: 'Education',
      child: (items == null || items.isEmpty)
          ? const Text('No education details added.', 
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14, fontStyle: FontStyle.normal))
          : Column(
              children: items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B4332).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.school_outlined, size: 20, color: Color(0xFF1B4332)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e['degree'] ?? '', 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827))),
                          const SizedBox(height: 2),
                          Text(e['institution'] ?? '', 
                            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
                          Text('${e['startDate'] ?? ''} - ${e['endDate'] ?? 'Present'}', 
                            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
    );
  }

  Widget _buildExperienceSection(List? items) {
    return _BaseCard(
      title: 'Work Experience',
      child: (items == null || items.isEmpty)
          ? const Text('No experience details added.', 
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14))
          : Column(
              children: items.map((ex) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B4332).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.business_center_outlined, size: 20, color: Color(0xFF1B4332)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ex['jobTitle'] ?? '', 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827))),
                          const SizedBox(height: 2),
                          Text(ex['companyName'] ?? '', 
                            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
                          Text('${ex['startDate'] ?? ''} - ${ex['endDate'] ?? 'Present'}', 
                            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                          if (ex['description'] != null && ex['description'].toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(ex['description'], 
                              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.4)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
    );
  }

  Widget _buildCertificateSection(List? items) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    return _BaseCard(
      title: 'Certificates',
      child: Column(
        children: items.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.verified_outlined, size: 20, color: Color(0xFF1B4332)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['name'] ?? '', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF111827))),
                    Text(c['organization'] ?? '', 
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildLinksSection(Map<String, dynamic> data) {
    bool hasLinks = (data['linkedin'] != null && data['linkedin'].toString().isNotEmpty) ||
                    (data['github'] != null && data['github'].toString().isNotEmpty) ||
                    (data['website'] != null && data['website'].toString().isNotEmpty);
    
    if (!hasLinks) return const SizedBox.shrink();

    return _BaseCard(
      title: 'Social & Portfolio Links',
      child: Column(
        children: [
          if (data['linkedin'] != null && data['linkedin'].toString().isNotEmpty)
            _buildLinkItem(Icons.link, 'LinkedIn', data['linkedin']),
          if (data['github'] != null && data['github'].toString().isNotEmpty)
            _buildLinkItem(Icons.code, 'GitHub', data['github']),
          if (data['website'] != null && data['website'].toString().isNotEmpty)
            _buildLinkItem(Icons.language, 'Website', data['website']),
        ],
      ),
    );
  }

  Widget _buildLinkItem(IconData icon, String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1B4332)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                Text(url, 
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2563EB), decoration: TextDecoration.underline),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
