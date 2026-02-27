import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Subscription Plans'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlock premium features and get the most out of NearBy Pro.',
              style: TextStyle(fontSize: 14, color: AppColors.textGray),
            ),
            const SizedBox(height: 32),
            _buildPlanCard(
              context,
              title: 'Free',
              price: '\$0',
              period: '/ month',
              features: [
                'Basic search access',
                'Up to 5 saved places',
                'Standard support',
              ],
              color: AppColors.textGray,
              isCurrent: true,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              title: 'Monthly Pro',
              price: '\$10',
              period: '/ month',
              features: [
                'Unlimited search access',
                'Unlimited saved places',
                'Priority support',
                'Advanced filters unlocked',
                'AI Career recommendations',
              ],
              color: AppColors.primary,
              isRecommended: true,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              title: 'Yearly Pro',
              price: '\$80',
              period: '/ year',
              subtitle: 'Save 33% compared to monthly',
              features: [
                'All Monthly Pro features',
                'Exclusive webinars access',
                'Offline map access',
                'Early access to new features',
              ],
              color: AppColors.secondary,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    String? subtitle,
    required List<String> features,
    required Color color,
    bool isRecommended = false,
    bool isCurrent = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isRecommended ? color : AppColors.border, width: isRecommended ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isRecommended)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
                child: const Text(
                  'RECOMMENDED',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textDark),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 2),
                      child: Text(
                        period,
                        style: const TextStyle(fontSize: 14, color: AppColors.textGray),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: color, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              f,
                              style: const TextStyle(fontSize: 14, color: AppColors.textGray),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: isCurrent ? 'Current Plan' : 'Select Plan',
                  onTap: isCurrent
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/payment-method', arguments: {'plan': title, 'price': price});
                        },
                  // Use a simpler approach if PrimaryButton color isn't easily changed via constructor in shared_widgets
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
