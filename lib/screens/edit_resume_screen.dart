import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EditResumeScreen extends StatelessWidget {
  const EditResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Edit Resume'),
          actions: [TextButton(onPressed: () {}, child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: [
              Tab(text: 'Personal'),
              Tab(text: 'Education'),
              Tab(text: 'Experience'),
              Tab(text: 'Skills'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _PersonalTab(),
            _EducationTab(),
            _ExperienceTab(),
            _SkillsTab(),
            _LinksTab(),
          ],
        ),
      ),
    );
  }
}

class _PersonalTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        _tf('Full Name', 'Your full name', Icons.person_outline_rounded),
        const SizedBox(height: 16),
        _tf('Professional Title', 'e.g. Flutter Developer', Icons.badge_outlined),
        const SizedBox(height: 16),
        _tf('Email', 'your@email.com', Icons.email_outlined),
        const SizedBox(height: 16),
        _tf('Phone', '+92 ---', Icons.phone_outlined),
        const SizedBox(height: 16),
        _tf('City', 'Your city', Icons.location_city_outlined),
        const SizedBox(height: 16),
        TextField(
          maxLines: 4,
          maxLength: 300,
          decoration: const InputDecoration(
            labelText: 'Professional Summary',
            hintText: 'Brief summary about yourself...',
            alignLabelWithHint: true,
          ),
        ),
      ],
    ),
  );

  Widget _tf(String label, String hint, IconData icon) => TextField(decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon, color: AppColors.textGray)));
}

class _EducationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Expanded(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.school_outlined, size: 52, color: AppColors.textLight),
              const SizedBox(height: 12),
              const Text('No education added', style: TextStyle(color: AppColors.textGray)),
            ]),
          ),
        ),
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_rounded), label: const Text('Add Education')),
      ],
    ),
  );
}

class _ExperienceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Expanded(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.work_outline_rounded, size: 52, color: AppColors.textLight),
              const SizedBox(height: 12),
              const Text('No experience added', style: TextStyle(color: AppColors.textGray)),
            ]),
          ),
        ),
        ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_rounded), label: const Text('Add Experience')),
      ],
    ),
  );
}

class _SkillsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        TextField(decoration: const InputDecoration(hintText: 'Type a skill and press add...', prefixIcon: Icon(Icons.add_circle_outline_rounded, color: AppColors.primary), suffixIcon: Icon(Icons.arrow_forward_rounded, color: AppColors.primary))),
        const SizedBox(height: 20),
        const Center(child: Text('No skills added yet', style: TextStyle(color: AppColors.textGray))),
      ],
    ),
  );
}

class _LinksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        _tf('LinkedIn', 'linkedin.com/in/username', Icons.link),
        const SizedBox(height: 16),
        _tf('GitHub', 'github.com/username', Icons.code_rounded),
        const SizedBox(height: 16),
        _tf('Portfolio', 'yourportfolio.com', Icons.web_rounded),
        const SizedBox(height: 16),
        _tf('Other Link', 'Paste URL here', Icons.add_link_rounded),
      ],
    ),
  );

  Widget _tf(String label, String hint, IconData icon) => TextField(decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon, color: AppColors.textGray)));
}
