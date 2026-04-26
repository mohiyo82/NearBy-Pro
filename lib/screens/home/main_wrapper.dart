import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'home_dashboard_screen.dart';
import '../search/global_search_screen.dart';
import '../results/saved_places_screen.dart';
import '../results/jobs_discovery_screen.dart';
import '../settings/settings_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboardScreen(),
    const GlobalSearchScreen(),
    const SavedPlacesScreen(),
    const JobsDiscoveryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SizedBox(
        height: 100, // Increased overall height
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ─── The Curved Background Bar ───
            Positioned(
              bottom: 0,
              left: 0,
              child: CustomPaint(
                size: Size(size.width, 80), // Bar height increased to 80
                painter: BNBCustomPainter(selectedIndex: _currentIndex),
              ),
            ),
            
            // ─── The Animated Floating Bubble ───
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              left: (size.width / 5) * _currentIndex + (size.width / 10) - 30,
              top: 5, // Perfectly centered in the larger bar
              child: Container(
                width: 60, // Slightly larger bubble
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3E4E),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  _getIcon(_currentIndex),
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            // ─── The Unselected Icons & Labels ───
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: size.width,
                height: 80,
                child: Row(
                  children: [
                    _buildNavItem(0, Icons.home_rounded, 'Home'),
                    _buildNavItem(1, Icons.search_rounded, 'Search'),
                    _buildNavItem(2, Icons.bookmark_rounded, 'Saved'),
                    _buildNavItem(3, Icons.work_rounded, 'Jobs'),
                    _buildNavItem(4, Icons.settings_rounded, 'Settings'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.search_rounded;
      case 2: return Icons.bookmark_rounded;
      case 3: return Icons.work_rounded;
      case 4: return Icons.settings_rounded;
      default: return Icons.home_rounded;
    }
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) 
              const SizedBox(height: 40) // Space for the larger floating bubble
            else ...[
              Icon(icon, color: const Color(0xFF455A64).withValues(alpha: 0.7), size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF455A64)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  final int selectedIndex;
  BNBCustomPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double itemWidth = size.width / 5;
    double centerX = itemWidth * selectedIndex + itemWidth / 2;

    Path path = Path();
    path.moveTo(0, 0); 
    path.lineTo(centerX - 45, 0);

    // Deep smooth curve adjusted for height 80
    path.cubicTo(
      centerX - 30, 0,
      centerX - 25, 45,
      centerX, 45,
    );
    path.cubicTo(
      centerX + 25, 45,
      centerX + 30, 0,
      centerX + 45, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.2), 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
