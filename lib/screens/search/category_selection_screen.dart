import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  static const List<_Cat> _cats = [
    _Cat('Healthcare', [
      _SubCat('Hospital', Icons.local_hospital_rounded, Color(0xFFE53935)),
      _SubCat('Clinic', Icons.medical_services_outlined, Color(0xFFEF5350)),
      _SubCat('Pharmacy', Icons.local_pharmacy_outlined, Color(0xFFF44336)),
      _SubCat('Lab / Diagnostic', Icons.biotech_rounded, Color(0xFFE57373)),
    ]),
    _Cat('Education', [
      _SubCat('School', Icons.school_rounded, Color(0xFFF57C00)),
      _SubCat('College', Icons.account_balance_outlined, Color(0xFFFF9800)),
      _SubCat('University', Icons.school_outlined, Color(0xFFFFA726)),
      _SubCat('Academy', Icons.auto_stories_outlined, Color(0xFFFFB74D)),
    ]),
    _Cat('Technology', [
      _SubCat('Software House', Icons.computer_rounded, AppColors.primary),
      _SubCat('IT Company', Icons.business_rounded, AppColors.primaryLight),
      _SubCat('Startup', Icons.rocket_launch_outlined, AppColors.accent),
      _SubCat('Agency', Icons.design_services_outlined, AppColors.secondary),
    ]),
    _Cat('Industry', [
      _SubCat('Factory', Icons.factory_rounded, Color(0xFF546E7A)),
      _SubCat('Warehouse', Icons.warehouse_outlined, Color(0xFF607D8B)),
      _SubCat('Manufacturing', Icons.precision_manufacturing_rounded, Color(0xFF455A64)),
      _SubCat('Export / Import', Icons.local_shipping_outlined, Color(0xFF78909C)),
    ]),
    _Cat('Finance', [
      _SubCat('Bank', Icons.account_balance_rounded, AppColors.secondary),
      _SubCat('Exchange', Icons.currency_exchange_rounded, Color(0xFF1565C0)),
      _SubCat('Insurance', Icons.shield_outlined, Color(0xFF1976D2)),
      _SubCat('Investment', Icons.show_chart_rounded, Color(0xFF42A5F5)),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Categories', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cats.length,
        itemBuilder: (context, i) {
          final cat = _cats[i];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 8),
                    Text(cat.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.6,
                ),
                itemCount: cat.subs.length,
                itemBuilder: (_, j) {
                  final sub = cat.subs[j];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/search-loading', arguments: sub.label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: sub.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(sub.icon, color: sub.color, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(sub.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark))),
                      ]),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _Cat {
  final String name;
  final List<_SubCat> subs;
  const _Cat(this.name, this.subs);
}

class _SubCat {
  final String label;
  final IconData icon;
  final Color color;
  const _SubCat(this.label, this.icon, this.color);
}
