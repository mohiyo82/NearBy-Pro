import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchResultsLoadingScreen extends StatefulWidget {
  const SearchResultsLoadingScreen({super.key});

  @override
  State<SearchResultsLoadingScreen> createState() => _SearchResultsLoadingScreenState();
}

class _SearchResultsLoadingScreenState extends State<SearchResultsLoadingScreen> {
  String _categoryName = 'Places';

  @override
  void initState() {
    super.initState();
    // Simulate location fetching and data loading for 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/results-list',
          arguments: _categoryName,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is String) {
      _categoryName = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Searching for $_categoryName...',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ]),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(color: Colors.white, backgroundColor: Colors.white30),
                  const SizedBox(height: 8),
                  const Text('Fetching your current location...',
                      style: TextStyle(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.location_searching_rounded, color: AppColors.primary, size: 52),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Finding $_categoryName nearby...',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    const Text('Checking GPS and local database...',
                        style: TextStyle(fontSize: 14, color: AppColors.textGray)),
                    const SizedBox(height: 48),
                    _AnimatedShimmerList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.border.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 14, width: double.infinity, decoration: BoxDecoration(color: AppColors.border.withOpacity(0.5), borderRadius: BorderRadius.circular(4))),
                        const SizedBox(height: 8),
                        Container(height: 10, width: 140, decoration: BoxDecoration(color: AppColors.border.withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
