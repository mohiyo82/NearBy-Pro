import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated tool icon container
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.construction_rounded, color: Color(0xFFFFA726), size: 60),
              ),
              const SizedBox(height: 32),
              const Text('Under Maintenance', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
              const SizedBox(height: 14),
              const Text(
                "We're currently performing scheduled maintenance to improve your experience. We'll be back shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
              ),
              const SizedBox(height: 36),
              // Status cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: Column(children: [
                  _StatusRow(label: 'Estimated completion', value: 'In ~2 hours', statusColor: const Color(0xFFFFA726)),
                  const Divider(height: 20, color: AppColors.border),
                  _StatusRow(label: 'Started at', value: '08:00 AM PKT', statusColor: AppColors.textGray),
                  const Divider(height: 20, color: AppColors.border),
                  _StatusRow(label: 'Status', value: 'In Progress', statusColor: AppColors.primary),
                ]),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Check Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('For urgent queries: support@nearbypro.app', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label, value;
  final Color statusColor;
  const _StatusRow({required this.label, required this.value, required this.statusColor});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor)),
    ],
  );
}
