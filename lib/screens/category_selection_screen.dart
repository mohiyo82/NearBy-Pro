import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
      appBar: AppBar(title: const Text('Select Category')),
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
                child: Text(cat.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
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
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                      ),
                      child: Row(children: [
                        Icon(sub.icon, color: sub.color, size: 22),
                        const SizedBox(width: 10),
                        Expanded(child: Text(sub.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark))),
                      ]),
                    ),
                  );
                },
              ),
              if (i < _cats.length - 1) const Divider(height: 24),
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
