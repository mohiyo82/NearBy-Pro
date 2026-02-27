import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Personal Details'),
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
            const StepProgress(current: 1, total: 5),
            const SizedBox(height: 28),
            const Text('Your Personal Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Please fill in your details accurately.', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
            const SizedBox(height: 28),
            const _FormRow(children: [
              _Field(label: 'First Name', hint: 'First name'),
              _Field(label: 'Last Name', hint: 'Last name'),
            ]),
            const SizedBox(height: 20),
            _field('Date of Birth', 'Select date', Icons.calendar_today_outlined),
            const SizedBox(height: 20),
            const Text('Gender', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                prefixIcon: const Icon(Icons.wc_rounded, color: AppColors.textGray),
              ),
              hint: const Text('Select gender'),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
                DropdownMenuItem(value: 'other', child: Text('Prefer not to say')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),
            _field('CNIC / National ID', 'XXXXX-XXXXXXX-X', Icons.badge_outlined),
            const SizedBox(height: 20),
            _field('Phone Number', '+92 --- -------', Icons.phone_outlined),
            const SizedBox(height: 20),
            _field('Current City', 'Your city', Icons.location_city_outlined),
            const SizedBox(height: 20),
            _field('Home Address', 'Street / Area / Sector', Icons.home_outlined),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/education-details'),
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
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 8),
        TextField(decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textGray))),
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  final List<Widget> children;
  const _FormRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, hint;
  const _Field({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      const SizedBox(height: 8),
      TextField(decoration: InputDecoration(hintText: hint)),
    ],
  );
}
