import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ResumeManagerScreen extends StatefulWidget {
  const ResumeManagerScreen({super.key});

  @override
  State<ResumeManagerScreen> createState() => _ResumeManagerScreenState();
}

class _ResumeManagerScreenState extends State<ResumeManagerScreen> {
  // Mock data for counts
  int _personalInfoCount = 1;
  int _educationCount = 2;
  int _experienceCount = 1;
  int _skillsCount = 5;
  int _resumeFileCount = 0;
  int _portfolioCount = 1;

  double get _completionPercentage {
    int filled = 0;
    if (_personalInfoCount > 0) filled++;
    if (_educationCount > 0) filled++;
    if (_experienceCount > 0) filled++;
    if (_skillsCount > 0) filled++;
    if (_resumeFileCount > 0) filled++;
    if (_portfolioCount > 0) filled++;
    return filled / 6;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    double progress = _completionPercentage;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Resume Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showSnackBar('Opening section selector...'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.secondary, AppColors.secondaryLight]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.description_rounded, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                const Text('Resume Completion', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Complete all sections to generate a professional PDF', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ]),
            ),
            const SizedBox(height: 32),
            const Text('Resume Sections', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 16),
            
            _buildSectionItem('Personal Info', Icons.person_outline_rounded, _personalInfoCount, AppColors.primary, '/personal-details'),
            _buildSectionItem('Education', Icons.school_outlined, _educationCount, AppColors.secondary, '/education-details'),
            _buildSectionItem('Experience', Icons.work_outline_rounded, _experienceCount, AppColors.accent, '/home'),
            _buildSectionItem('Skills', Icons.psychology_outlined, _skillsCount, const Color(0xFF7E57C2), '/skills-selection'),
            _buildSectionItem('Resume File', Icons.upload_file_rounded, _resumeFileCount, const Color(0xFFE53935), '/resume-upload'),
            _buildSectionItem('Portfolio Links', Icons.link_rounded, _portfolioCount, const Color(0xFF00897B), '/profile-preview'),
            
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Edit Full Resume',
              icon: Icons.edit_rounded,
              onTap: () => Navigator.pushNamed(context, '/edit-resume'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: progress < 1.0 
                  ? () => _showSnackBar('Please complete your profile first (currently ${(progress * 100).toInt()}%)')
                  : () => _showSnackBar('Generating PDF Resume...'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
              label: const Text('Download PDF Resume', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionItem(String title, IconData icon, int count, Color color, String route) {
    bool isComplete = count > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(
                      isComplete ? '$count entries added' : 'Action Required',
                      style: TextStyle(fontSize: 12, color: isComplete ? AppColors.success : AppColors.error, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Icon(
                isComplete ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                color: isComplete ? AppColors.success : AppColors.textLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
