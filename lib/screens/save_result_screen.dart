import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SaveResultScreen extends StatelessWidget {
  const SaveResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Save to Collection')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.business_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Company Name', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark, fontSize: 15)),
                  Text('Software House • Lahore', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                ])),
                const Icon(Icons.bookmark_rounded, color: AppColors.primary),
              ]),
            ),
            const SizedBox(height: 24),
            const Text('Save to Collection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 14),
            ...['Favourites', 'Job Targets', 'Will Apply Later', 'Interesting Places'].map((name) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
                  child: Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.folder_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const Text('0 saved', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                    ])),
                    Radio(value: false, groupValue: null, onChanged: (_) {}, activeColor: AppColors.primary),
                  ]),
                ),
              ),
            )),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4), style: BorderStyle.solid, width: 1.5),
                ),
                child: const Row(children: [
                  Icon(Icons.create_new_folder_rounded, color: AppColors.primary),
                  SizedBox(width: 12),
                  Text('Create New Collection', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]),
              ),
            ),
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text('Save')),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
