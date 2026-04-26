import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Initial scale is 1.0. Final scale is reduced for a smoother professional effect.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _navigateToNext();
  }

  void _navigateToNext() async {
    // Show the logo for exactly 3 seconds as requested
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Start the zoom-in explosion animation
      await _controller.forward();
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding1');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: _buildExactLogo(),
          ),
        ),
      ),
    );
  }

  // Building the logo precisely as shown in your image
  Widget _buildExactLogo() {
    return SizedBox(
      width: 120,
      height: 140,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // The Main Green Pin (Points downwards)
          const Icon(
            Icons.location_on_rounded,
            size: 110,
            color: Color(0xFF2E7D32),
          ),
          // White circle with briefcase in the center of the pin's head
          Positioned(
            top: 22,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business_center_rounded,
                color: Color(0xFF2E7D32),
                size: 28,
              ),
            ),
          ),
          // Small Search Icon at the bottom right
          Positioned(
            bottom: 25,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Color(0xFF2E7D32),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
