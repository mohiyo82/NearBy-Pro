import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': 'How does distance search work?', 'a': 'We use your selected location or GPS to calculate straight-line distance to each result. You can set the radius from 10km to 100km in filters.'},
      {'q': 'Can I search without GPS?', 'a': 'Yes! You can manually select any city or area from the City/Area Selection screens without enabling GPS.'},
      {'q': 'How do I upload my resume?', 'a': 'Go to Profile → Resume Manager → Upload Resume. Supported formats: PDF, DOC, DOCX (max 5MB).'},
      {'q': 'What types of places can I find?', 'a': 'You can search for any type: hospitals, schools, software houses, factories, banks, restaurants, hotels, and more with custom keywords.'},
    ];

    final channels = [
      {'icon': Icons.email_rounded, 'label': 'Email Support', 'value': 'support@nearbypro.app', 'color': AppColors.secondary},
      {'icon': Icons.chat_bubble_rounded, 'label': 'Live Chat', 'value': 'Available 9AM–6PM PKT', 'color': AppColors.primary},
      {'icon': Icons.phone_rounded, 'label': 'Phone', 'value': '+92-21-111-NEARBY', 'color': const Color(0xFF7C3AED)},
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search in help
          TextField(
            decoration: InputDecoration(
              hintText: 'Search help topics...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 20),

          // Quick help topics
          const Text('Popular Topics', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ['Getting Started', 'Map Search', 'Resume Upload', 'Notifications', 'Account Issues', 'Privacy'].map((t) =>
              ActionChip(
                label: Text(t, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                side: BorderSide.none,
                onPressed: () {},
              )
            ).toList(),
          ),
          const SizedBox(height: 24),

          // FAQs
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(
              children: faqs.asMap().entries.map((e) {
                final isLast = e.key == faqs.length - 1;
                final faq = e.value;
                return Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(faq['q']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        iconColor: AppColors.primary, collapsedIconColor: AppColors.textGray,
                        children: [Text(faq['a']!, style: const TextStyle(fontSize: 13, color: AppColors.textGray, height: 1.5))],
                      ),
                    ),
                    if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Contact channels
          const Text('Contact Us', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 10),
          ...channels.map((c) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(color: (c['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(c['icon'] as IconData, color: c['color'] as Color, size: 22)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['label'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  Text(c['value'] as String, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textLight),
              ],
            ),
          )).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
