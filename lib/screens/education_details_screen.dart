import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class EducationDetailsScreen extends StatefulWidget {
  const EducationDetailsScreen({super.key});

  @override
  State<EducationDetailsScreen> createState() => _EducationDetailsScreenState();
}

class _EducationDetailsScreenState extends State<EducationDetailsScreen> {
  int _educationCount = 1;

  void _addEducation() {
    setState(() {
      _educationCount++;
    });
  }

  void _removeEducation() {
    if (_educationCount > 1) {
      setState(() {
        _educationCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Education Details'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgress(current: 2, total: 5),
            const SizedBox(height: 28),
            const Text('Your Education', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Add your educational background.', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
            const SizedBox(height: 28),
            ...List.generate(_educationCount, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _EduCard(
                index: index + 1,
                onRemove: index > 0 ? _removeEducation : null,
              ),
            )),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addEducation,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add_rounded, color: AppColors.primary),
              label: const Text('Add Another Degree', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/skills-selection'),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text(
                  'I\'ll do this later',
                  style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _EduCard extends StatelessWidget {
  final int index;
  final VoidCallback? onRemove;
  const _EduCard({required this.index, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_outlined, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Degree $index', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const Spacer(),
              if (onRemove != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Degree Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            hint: const Text('Select degree'),
            items: const [
              DropdownMenuItem(value: 'matric', child: Text('Matric / O-Level')),
              DropdownMenuItem(value: 'intermediate', child: Text('Intermediate / A-Level')),
              DropdownMenuItem(value: 'bachelors', child: Text('Bachelor\'s')),
              DropdownMenuItem(value: 'masters', child: Text('Master\'s')),
              DropdownMenuItem(value: 'phd', child: Text('PhD')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          _tf('Institution Name', 'University / College / School'),
          const SizedBox(height: 12),
          _tf('Field of Study', 'e.g. Computer Science'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _tf('Start Year', '20XX')),
              const SizedBox(width: 12),
              Expanded(child: _tf('End Year', '20XX or Present')),
            ],
          ),
          const SizedBox(height: 12),
          _tf('GPA / Grade / Marks', 'e.g. 3.8 / 4.0 or 85%'),
        ],
      ),
    );
  }

  Widget _tf(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textGray)),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          ),
        ),
      ],
    );
  }
}
