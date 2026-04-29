import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_dashboard_screen.dart';
import '../search/global_search_screen.dart';
import '../results/saved_places_screen.dart';
import '../results/jobs_discovery_screen.dart';
import '../settings/settings_screen.dart';
import '../company/company_dashboard_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Regular User Screens
  final List<Widget> _userScreens = [
    const HomeDashboardScreen(),
    const GlobalSearchScreen(),
    const SavedPlacesScreen(),
    const JobsDiscoveryScreen(),
    const SettingsScreen(),
  ];

  // Company Mode Screens
  final List<Widget> _companyScreens = [
    const CompanyDashboardScreen(),
    const GlobalSearchScreen(), // Companies can also search
    const JobsDiscoveryScreen(), // See other jobs
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).snapshots(),
      builder: (context, snapshot) {
        bool isCompanyMode = false;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          isCompanyMode = data['activeMode'] == 'company';
        }

        final screens = isCompanyMode ? _companyScreens : _userScreens;
        final itemCount = screens.length;

        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: _currentIndex >= itemCount ? 0 : _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: _buildBottomNav(isCompanyMode, itemCount),
        );
      },
    );
  }

  Widget _buildBottomNav(bool isCompanyMode, int count) {
    final Size size = MediaQuery.of(context).size;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double barHeight = size.height * 0.075;
    final double totalHeight = barHeight + bottomPadding + 4;
    final double bubbleSize = size.height * 0.068;
    final double iconSize = size.height * 0.028;

    return Container(
      height: totalHeight,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              size: Size(size.width, totalHeight),
              painter: BNBCustomPainter(
                selectedIndex: _currentIndex,
                barHeight: totalHeight,
                itemCount: count,
              ),
            ),
          ),
          ...List.generate(count, (index) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              left: (size.width / count) * index + (size.width / (count * 2)) - bubbleSize / 2,
              top: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _currentIndex == index ? 1.0 : 0.0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.elasticOut,
                  scale: _currentIndex == index ? 1.0 : 0.4,
                  child: Material(
                    elevation: 6,
                    shadowColor: Colors.black26,
                    shape: const CircleBorder(),
                    child: Container(
                      width: bubbleSize,
                      height: bubbleSize,
                      decoration: BoxDecoration(
                        color: isCompanyMode ? const Color(0xFF1B4332) : const Color(0xFF2D3E4E),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIcon(index, isCompanyMode),
                        color: Colors.white,
                        size: iconSize + 2,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          Positioned(
            bottom: bottomPadding,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: barHeight,
              child: Row(
                children: List.generate(
                  count,
                  (index) => _buildNavItem(index, iconSize, bubbleSize, isCompanyMode, count),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, double iconSize, double bubbleSize, bool isCompanyMode, int count) {
    final bool isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              SizedBox(height: bubbleSize)
            else ...[
              Icon(
                _getIcon(index, isCompanyMode),
                color: const Color(0xFF455A64),
                size: iconSize,
              ),
              const SizedBox(height: 3),
              Text(
                _getLabel(index, isCompanyMode),
                style: TextStyle(
                  fontSize: iconSize * 0.42,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF455A64),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index, bool isCompanyMode) {
    if (isCompanyMode) {
      switch (index) {
        case 0: return Icons.business_center_rounded;
        case 1: return Icons.search_rounded;
        case 2: return Icons.work_outline_rounded;
        case 3: return Icons.settings_rounded;
        default: return Icons.business_center_rounded;
      }
    }
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.search_rounded;
      case 2: return Icons.bookmark_rounded;
      case 3: return Icons.work_rounded;
      case 4: return Icons.settings_rounded;
      default: return Icons.home_rounded;
    }
  }

  String _getLabel(int index, bool isCompanyMode) {
    if (isCompanyMode) {
      switch (index) {
        case 0: return 'Dashboard';
        case 1: return 'Search';
        case 2: return 'Jobs';
        case 3: return 'Settings';
        default: return '';
      }
    }
    switch (index) {
      case 0: return 'Home';
      case 1: return 'Search';
      case 2: return 'Saved';
      case 3: return 'Jobs';
      case 4: return 'Settings';
      default: return '';
    }
  }
}

class BNBCustomPainter extends CustomPainter {
  final int selectedIndex;
  final double barHeight;
  final int itemCount;

  BNBCustomPainter({
    required this.selectedIndex,
    required this.barHeight,
    required this.itemCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double itemWidth = size.width / itemCount;
    final double centerX = itemWidth * selectedIndex + itemWidth / 2;
    final double curveDepth = barHeight * 0.42;
    const double curveWidth = 38.0;
    const double curveRadius = 26.0;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(centerX - curveWidth - 10, 0);

    path.cubicTo(
      centerX - curveWidth,      0,
      centerX - curveRadius,     curveDepth,
      centerX,                   curveDepth,
    );
    path.cubicTo(
      centerX + curveRadius,     curveDepth,
      centerX + curveWidth,      0,
      centerX + curveWidth + 10, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 8, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BNBCustomPainter old) =>
      old.selectedIndex != selectedIndex || old.itemCount != itemCount;
}
