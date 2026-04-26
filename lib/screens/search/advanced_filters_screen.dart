import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AdvancedFiltersScreen extends StatefulWidget {
  const AdvancedFiltersScreen({super.key});

  @override
  State<AdvancedFiltersScreen> createState() => _AdvancedFiltersScreenState();
}

class _AdvancedFiltersScreenState extends State<AdvancedFiltersScreen> {
  String _selectedSort = 'Nearest';
  int _selectedRating = 4;
  String _selectedBusinessType = 'All Types';
  bool _isCurrentlyHiring = true;
  bool _isInternshipsAvailable = false;
  bool _hasPhoneNumber = false;
  bool _hasEmailAddress = false;
  bool _hasWebsite = false;

  void _resetFilters() {
    setState(() {
      _selectedSort = 'Nearest';
      _selectedRating = 4;
      _selectedBusinessType = 'All Types';
      _isCurrentlyHiring = true;
      _isInternshipsAvailable = false;
      _hasPhoneNumber = false;
      _hasEmailAddress = false;
      _hasWebsite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Advanced Filters'),
        actions: [
          TextButton(onPressed: _resetFilters, child: const Text('Reset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSection(
              title: 'Sort By',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['Nearest', 'Relevance', 'Rating', 'Most Reviews', 'Newest'].map((s) {
                  return _Chip(label: s, selected: _selectedSort == s, onTap: () => setState(() => _selectedSort = s));
                }).toList(),
              ),
            ),
            const Divider(height: 48, thickness: 1),
            _FilterSection(
              title: 'Minimum Rating',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [1, 2, 3, 4, 5].map((r) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRating = r),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedRating == r ? AppColors.warning.withValues(alpha: 0.12) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _selectedRating == r ? AppColors.warning : AppColors.border, width: _selectedRating == r ? 1.5 : 1),
                        ),
                        child: Row(children: [Icon(Icons.star_rounded, size: 18, color: _selectedRating == r ? AppColors.warning : Colors.grey[400]), const SizedBox(width: 6), Text('$r Stars', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _selectedRating == r ? AppColors.warning : AppColors.textDark))]),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            const Divider(height: 48, thickness: 1),
            _FilterSection(
              title: 'Business Category',
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ['All Types', 'Private', 'Government', 'NGO', 'Startup', 'MNC'].map((s) {
                  return _Chip(label: s, selected: _selectedBusinessType == s, onTap: () => setState(() => _selectedBusinessType = s));
                }).toList(),
              ),
            ),
            const Divider(height: 48, thickness: 1),
            _FilterSection(
              title: 'Career Opportunities',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: Column(children: [
                  _SwitchTile(label: 'Currently Hiring', sub: 'Show places with open jobs', value: _isCurrentlyHiring, onChanged: (val) => setState(() => _isCurrentlyHiring = val)),
                  const Divider(height: 1),
                  _SwitchTile(label: 'Internships', sub: 'For students/freshers', value: _isInternshipsAvailable, onChanged: (val) => setState(() => _isInternshipsAvailable = val)),
                ]),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _FilterSection({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: 0.3)), const SizedBox(height: 16), child]);
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, this.selected = false, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: selected ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? AppColors.primary : AppColors.border)),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.textDark)),
    ),
  );
}

class _SwitchTile extends StatelessWidget {
  final String label, sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({required this.label, required this.sub, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)), Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGray))])),
      Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary, activeTrackColor: AppColors.primary.withValues(alpha: 0.2)),
    ]),
  );
}
