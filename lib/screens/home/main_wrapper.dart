import 'package:flutter/material.dart';
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
    // ✅ Safe area bottom padding (home indicator wali space)
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        // ✅ Height bhari: bar (85) + bottom safe area + extra padding (12)
        height: 85 + bottomPadding + 12,
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ─── White curved background bar ───
            Positioned(
              bottom: 0,
              left: 0,
              child: CustomPaint(
                size: Size(size.width, 85 + bottomPadding + 12),
                painter: BNBCustomPainter(selectedIndex: _currentIndex),
              ),
            ),

            // ─── Animated floating bubble ───
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: (size.width / 5) * _currentIndex +
                  (size.width / 10) -
                  32, // ✅ bubble thoda bada (64/2)
              top: 0,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black38,
                shape: const CircleBorder(),
                child: Container(
                  width: 64,  // ✅ Bubble bada kiya
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D3E4E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(_currentIndex),
                    color: Colors.white,
                    size: 32, // ✅ Selected icon bada
                  ),
                ),
              ),
            ),

            // ─── Unselected icons & labels ───
            Positioned(
              bottom: bottomPadding + 6, // ✅ bottom padding ke sath shift
              left: 0,
              child: SizedBox(
                width: size.width,
                height: 75,
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
    final bool isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const SizedBox(height: 64) // ✅ bubble size ke barabar space
            else ...[
              Icon(
                icon,
                color: const Color(0xFF455A64),
                size: 30, // ✅ Unselected icons bade kiye
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF455A64),
                ),
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
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double itemWidth = size.width / 5;
    final double centerX = itemWidth * selectedIndex + itemWidth / 2;

    const double curveDepth = 38.0;
    const double curveWidth = 42.0;
    const double curveRadius = 30.0;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(centerX - curveWidth - 12, 0);

    path.cubicTo(
      centerX - curveWidth,  0,
      centerX - curveRadius, curveDepth,
      centerX,               curveDepth,
    );
    path.cubicTo(
      centerX + curveRadius, curveDepth,
      centerX + curveWidth,  0,
      centerX + curveWidth + 12, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 10, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BNBCustomPainter old) =>
      old.selectedIndex != selectedIndex;
}