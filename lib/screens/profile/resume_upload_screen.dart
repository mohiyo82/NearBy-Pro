import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class Achievement {
  final String certificateName;
  final String description;
  Achievement(this.certificateName, this.description);
}

class Language {
  final String name;
  final String flag;
  const Language(this.name, this.flag);
}

class ResumeUploadScreen extends StatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  String? _uploadedFileName;
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _websiteController = TextEditingController();
  final Set<String> _selectedLanguages = {};
  final List<Achievement> _achievements = [];

  void _simulateFileUpload() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening file picker...'), duration: Duration(seconds: 1)));
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _uploadedFileName = 'John_Doe_Resume_2024.pdf');
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded: $_uploadedFileName'), backgroundColor: AppColors.success));
  }

  void _deleteResume() {
    setState(() => _uploadedFileName = null);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resume removed.'), backgroundColor: AppColors.error));
  }

  void _showLinksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Portfolio & Links'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _linkedinController, decoration: const InputDecoration(labelText: 'LinkedIn URL')),
            const SizedBox(height: 12),
            TextField(controller: _githubController, decoration: const InputDecoration(labelText: 'GitHub URL')),
            const SizedBox(height: 12),
            TextField(controller: _websiteController, decoration: const InputDecoration(labelText: 'Website URL')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save Links')),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final allLanguages = [const Language('Urdu', '🇵🇰'), const Language('English', '🇬🇧'), const Language('Arabic', '🇸🇦')];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Select Languages'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: allLanguages.length,
                itemBuilder: (context, index) {
                  final lang = allLanguages[index];
                  return CheckboxListTile(
                    title: Text('${lang.flag} ${lang.name}'),
                    value: _selectedLanguages.contains(lang.name),
                    onChanged: (bool? value) {
                      setDialogState(() {
                        if (value == true) _selectedLanguages.add(lang.name);
                        else _selectedLanguages.remove(lang.name);
                      });
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
          );
        },
      ),
    );
  }

  void _showAchievementDialog() {
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Achievement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_rounded), label: const Text('Upload Certificate')),
            const SizedBox(height: 12),
            TextField(controller: descController, decoration: const InputDecoration(hintText: 'Description...'), maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _achievements.add(Achievement('cert.jpg', descController.text)));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Build Your Resume')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgress(current: 4, total: 5),
            const SizedBox(height: 28),
            const Text('Upload or Build Your Resume', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 20),
            if (_uploadedFileName == null) GestureDetector(onTap: _simulateFileUpload, child: _UploadBox())
            else _UploadedFileCard(fileName: _uploadedFileName!, onDelete: _deleteResume),
            const SizedBox(height: 24),
            const Center(child: Text('— or build your resume here —', style: TextStyle(color: AppColors.textLight, fontSize: 13))),
            const SizedBox(height: 24),
            _SectionCard(icon: Icons.work_outline_rounded, title: 'Work Experience', subtitle: 'Add your past roles', color: AppColors.secondary, onTap: () {}),
            const SizedBox(height: 12),
            _SectionCard(icon: Icons.emoji_events_outlined, title: 'Achievements & Awards', subtitle: '${_achievements.length} entries added', color: AppColors.accent, onTap: _showAchievementDialog),
            if (_achievements.isNotEmpty) _AchievementList(achievements: _achievements, onRemove: (index) => setState(() => _achievements.removeAt(index))),
            const SizedBox(height: 12),
            _SectionCard(icon: Icons.language_rounded, title: 'Languages', subtitle: '${_selectedLanguages.length} languages added', color: AppColors.primaryLight, onTap: _showLanguageDialog),
            const SizedBox(height: 12),
            _SectionCard(icon: Icons.link_rounded, title: 'Portfolio / Links', subtitle: 'LinkedIn, GitHub, Website', color: const Color(0xFF7E57C2), onTap: _showLinksDialog),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/profile-preview'), child: const Text('Save & Continue')),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/home'), child: const Text('Skip for Now', style: TextStyle(color: AppColors.textGray))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 48),
    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2, style: BorderStyle.solid)),
    child: const Column(children: [Icon(Icons.upload_file_rounded, color: AppColors.primary, size: 36), SizedBox(height: 16), Text('Tap to Upload Resume', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)), SizedBox(height: 8), Text('PDF or DOCX • Max 5MB', style: TextStyle(fontSize: 13, color: AppColors.textGray))]),
  );
}

class _UploadedFileCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onDelete;
  const _UploadedFileCard({required this.fileName, required this.onDelete});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Row(children: [const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 32), const SizedBox(width: 14), Expanded(child: Text(fileName, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark))), IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error), onPressed: onDelete)]),
  );
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _SectionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)), Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray))])), const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary)]),
    ),
  );
}

class _AchievementList extends StatelessWidget {
  final List<Achievement> achievements;
  final ValueChanged<int> onRemove;
  const _AchievementList({required this.achievements, required this.onRemove});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8), padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
    child: Column(children: achievements.asMap().entries.map((entry) {
      final index = entry.key; final achievement = entry.value;
      return ListTile(leading: const Icon(Icons.verified_user_outlined, color: AppColors.accent), title: Text(achievement.certificateName, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(achievement.description), trailing: IconButton(icon: const Icon(Icons.remove_circle_outline, color: AppColors.error), onPressed: () => onRemove(index)));
    }).toList()),
  );
}
