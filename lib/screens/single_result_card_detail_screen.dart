import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SingleResultCardDetailScreen extends StatelessWidget {
  const SingleResultCardDetailScreen({super.key});

  void _showAppliedMessage(BuildContext context, String position) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('Applied for $position Successfully!')),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing company profile...'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved to your places'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.business_rounded, size: 80, color: AppColors.primary),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Company Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: const Text('Software House', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: const Text('Hiring', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      const Column(
                        children: [
                          Text('4.5', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.warning)),
                          Row(children: [
                            Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                            Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                            Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                            Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                            Icon(Icons.star_half_rounded, size: 14, color: AppColors.warning),
                          ]),
                          Text('124 reviews', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: _QuickStat(icon: Icons.location_on_rounded, label: '3.2 km', sub: 'Distance', color: AppColors.primary)),
                      SizedBox(width: 10),
                      Expanded(child: _QuickStat(icon: Icons.people_rounded, label: '250+', sub: 'Employees', color: AppColors.secondary)),
                      SizedBox(width: 10),
                      Expanded(child: _QuickStat(icon: Icons.work_rounded, label: '12', sub: 'Open Roles', color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionHeader(title: 'About'),
                  const SizedBox(height: 8),
                  const Text(
                    'Company description and details will appear here. This section gives a brief overview of what the company does, its specialization, and key highlights.',
                    style: TextStyle(fontSize: 14, color: AppColors.textGray, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  const _SectionHeader(title: 'Contact Information'),
                  const SizedBox(height: 12),
                  const _ContactRow(icon: Icons.phone_outlined, label: 'Phone', value: '+92 300 1234567'),
                  const _ContactRow(icon: Icons.email_outlined, label: 'Email', value: 'contact@company.com'),
                  const _ContactRow(icon: Icons.language_rounded, label: 'Website', value: 'www.company.com'),
                  const _ContactRow(icon: Icons.location_on_outlined, label: 'Address', value: 'Street, Area, City, Pakistan'),
                  const SizedBox(height: 20),
                  const _SectionHeader(title: 'Open Positions'),
                  const SizedBox(height: 12),
                  ...['Flutter Developer', 'Python Developer', 'UI/UX Designer'].map((j) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        const Icon(Icons.work_outline_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(j.trim(), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark))),
                        TextButton(
                          onPressed: () => _showAppliedMessage(context, j.trim()),
                          child: const Text('Apply', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ]),
                    ),
                  )),
                  const SizedBox(height: 20),
                  const _SectionHeader(title: 'Location on Map'),
                  const SizedBox(height: 12),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_rounded, size: 40, color: AppColors.primary),
                        SizedBox(height: 8),
                        Text('Map Placeholder', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w600)),
                      ],
                    )),
                  ),
                  const SizedBox(height: 40),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Starting call...'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
                        label: const Text('Call', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => _showAppliedMessage(context, 'General Position'),
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Apply / Connect'),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Row(children: [
    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
    const SizedBox(width: 8),
    const Expanded(child: Divider()),
  ]);
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  const _QuickStat({required this.icon, required this.label, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
    ]),
  );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ContactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          ]),
        ),
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.textLight),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Copied $label to clipboard'), behavior: SnackBarBehavior.floating),
            );
          },
        ),
      ]),
    );
  }
}
