import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About App'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 24),
          const Text('NearBy Pro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark)),
          const Text('v1.0.0 (Build 2026)', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
          const SizedBox(height: 40),
          const Text(
            'NearBy Pro is a comprehensive smart location and career finder designed to bridge the gap between people and local opportunities. Whether you are looking for medical assistance, educational institutions, or your next career milestone, we bring everything to your fingertips.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textGray, height: 1.6),
          ),
        ]),
      ),
    );
  }
}
