import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultsMapViewScreen extends StatelessWidget {
  const ResultsMapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Map View', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Software Houses • Lahore', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.list_rounded), onPressed: () {}, tooltip: 'List View'),
          IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade50, Colors.blue.shade50, Colors.green.shade100],
              ),
            ),
            child: CustomPaint(painter: _MapGridPainter()),
          ),
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 2),
              ),
              child: const Icon(Icons.my_location_rounded, color: AppColors.secondary, size: 28),
            ),
          ),
          ..._dummyPins().map((p) => Positioned(left: p['x']!, top: p['y']!, child: _MapPin(label: p['label']!))),
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12)],
              ),
              child: Row(children: [
                const Icon(Icons.search_rounded, color: AppColors.textGray, size: 20),
                const SizedBox(width: 8),
                const Expanded(child: Text('Search in this area', style: TextStyle(fontSize: 14, color: AppColors.textGray))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Redo', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 180,
            child: Column(
              children: [
                _MapButton(icon: Icons.add_rounded),
                const SizedBox(height: 8),
                _MapButton(icon: Icons.remove_rounded),
                const SizedBox(height: 8),
                _MapButton(icon: Icons.my_location_rounded),
                const SizedBox(height: 8),
                _MapButton(icon: Icons.layers_rounded),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, -4))],
              ),
              child: Column(
                children: [
                  Container(margin: const EdgeInsets.only(top: 10), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(children: [
                      Text('0 places found', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      Spacer(),
                      Text('in 25 km radius', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                    ]),
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder: (_, i) => Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Company Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                          const SizedBox(height: 4),
                          const Text('Software House', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          const Row(children: [
                            Icon(Icons.location_on_rounded, size: 12, color: AppColors.textGray),
                            SizedBox(width: 2),
                            Text('0 km away', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
                            Spacer(),
                            Icon(Icons.star_rounded, size: 12, color: AppColors.warning),
                            Text('0.0', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
                          ]),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, double>> _dummyPins() => [
    {'x': 80, 'y': 180, 'label': 1},
    {'x': 220, 'y': 130, 'label': 2},
    {'x': 300, 'y': 280, 'label': 3},
    {'x': 140, 'y': 340, 'label': 4},
    {'x': 260, 'y': 420, 'label': 5},
  ].map((e) => {'x': e['x']!.toDouble(), 'y': e['y']!.toDouble(), 'label': e['label']!.toDouble()}).toList();
}

class _MapPin extends StatelessWidget {
  final double label;
  const _MapPin({required this.label});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 44,
        height: 28,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
        child: Center(child: Text('0 km', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
      ),
      CustomPaint(size: const Size(12, 8), painter: _PinTailPainter()),
    ],
  );
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  const _MapButton({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
    ),
    child: Icon(icon, size: 20, color: AppColors.textGray),
  );
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.07)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
