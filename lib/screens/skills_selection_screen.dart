import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class SkillsSelectionScreen extends StatefulWidget {
  const SkillsSelectionScreen({super.key});

  @override
  State<SkillsSelectionScreen> createState() => _SkillsSelectionScreenState();
}

class _SkillsSelectionScreenState extends State<SkillsSelectionScreen> {
  final List<String> _skills = [
    'Flutter', 'Python', 'JavaScript', 'React', 'Node.js', 'Java', 'C++', 'Kotlin',
    'Swift', 'UI/UX Design', 'Photoshop', 'Figma', 'AutoCAD', 'Excel', 'Data Analysis',
    'Machine Learning', 'Communication', 'Teamwork', 'Leadership', 'Project Management',
    'Marketing', 'Sales', 'Accounting', 'Finance', 'Medical', 'Teaching', 'Research',
    'Photography', 'Video Editing', 'Networking', 'Cybersecurity', 'Cloud (AWS)',
  ];

  final Set<String> _selectedSkills = {'Flutter', 'Python', 'Communication'};
  final TextEditingController _searchController = TextEditingController();

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _addCustomSkill() {
    final customSkill = _searchController.text.trim();
    if (customSkill.isNotEmpty) {
      setState(() {
        if (!_skills.contains(customSkill)) {
          _skills.insert(0, customSkill);
        }
        _selectedSkills.add(customSkill);
        _searchController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Skills')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgress(current: 3, total: 5),
            const SizedBox(height: 28),
            const Text('Select Your Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Choose skills that represent your expertise.', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onSubmitted: (_) => _addCustomSkill(),
              decoration: InputDecoration(
                hintText: 'Search or add a custom skill...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGray),
                suffixIcon: TextButton(
                  onPressed: _addCustomSkill,
                  child: const Text('Add', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text('${_selectedSkills.length} skills selected', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _skills.map((s) {
                    final isSelected = _selectedSkills.contains(s);
                    return GestureDetector(
                      onTap: () => _toggleSkill(s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                              const SizedBox(width: 6),
                            ],
                            Text(s, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textDark)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/resume-upload'),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
