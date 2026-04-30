import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class AppGuideScreen extends StatefulWidget {
  const AppGuideScreen({super.key});

  @override
  State<AppGuideScreen> createState() => _AppGuideScreenState();
}

class _AppGuideScreenState extends State<AppGuideScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _guideSteps = [
    {
      'title': 'Welcome to NearBy Pro',
      'desc': 'Discover hospitals, schools, IT companies, and job opportunities right in your neighborhood.',
      'image': 'assets/images/onbording_1.jpeg',
    },
    {
      'title': 'Smart Local Search',
      'desc': 'Use our advanced location engine to find businesses within your preferred radius.',
      'image': 'assets/images/onbording_2.jpeg',
    },
    {
      'title': 'Professional Profile',
      'desc': 'Build a strong profile with your education and skills to get noticed by local employers.',
      'image': 'assets/images/onbording_3.jpeg',
    },
    {
      'title': 'Resume Manager',
      'desc': 'Create and manage professional resumes easily. Apply to any job with just one click.',
      'image': 'assets/images/onbording_1.jpeg',
    },
    {
      'title': 'Apply & Connect',
      'desc': 'Connect directly with verified companies and track your applications in real-time.',
      'image': 'assets/images/onbording_2.jpeg',
    },
    {
      'title': 'Go Pro for More',
      'desc': 'Unlock AI-powered career recommendations and unlimited features with our premium plans.',
      'image': 'assets/images/onbording_3.jpeg',
    },
  ];

  void _onNext() {
    if (_currentPage < _guideSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishGuide();
    }
  }

  void _finishGuide() {
    // Navigate to Home and clear stack
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentPage + 1} of ${_guideSteps.length}',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: _finishGuide,
                    child: const Text(
                      'Skip Guide',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _guideSteps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: AssetImage(_guideSteps[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          _guideSteps[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _guideSteps[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textGray,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _guideSteps.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    label: _currentPage == _guideSteps.length - 1 ? 'Start Using App' : 'Next Step',
                    onTap: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
