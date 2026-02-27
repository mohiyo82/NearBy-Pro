import 'package:flutter/material.dart';

class PermissionRequestScreen extends StatelessWidget {
  const PermissionRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.location_on_rounded, size: 64, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 32),
              const Text('Allow Location Access', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF212121)), textAlign: TextAlign.center),
              const SizedBox(height: 14),
              const Text('NearBy Pro needs your location to find places, companies, and opportunities near you.', style: TextStyle(color: Color(0xFF757575), fontSize: 15, height: 1.6), textAlign: TextAlign.center),
              const SizedBox(height: 36),
              ...[
                ['Find nearby places instantly', Icons.speed_rounded],
                ['Accurate distance calculation', Icons.social_distance_rounded],
                ['Map view of results', Icons.map_rounded],
              ].map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)), child: Icon(item[1] as IconData, color: const Color(0xFF2E7D32), size: 22)),
                  const SizedBox(width: 14),
                  Text(item[0] as String, style: const TextStyle(color: Color(0xFF424242), fontSize: 15, fontWeight: FontWeight.w500)),
                ]),
              )),
              const SizedBox(height: 36),
              SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('Allow Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              )),
              const SizedBox(height: 14),
              TextButton(onPressed: () {}, child: const Text('Not Now', style: TextStyle(color: Color(0xFF9E9E9E)))),
            ],
          ),
        ),
      ),
    );
  }
}