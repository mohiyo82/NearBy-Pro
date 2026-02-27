import 'package:flutter/material.dart';

class LocationDisabledScreen extends StatelessWidget {
  const LocationDisabledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: const BoxDecoration(color: Color(0xFFFFF3E0), shape: BoxShape.circle),
              child: const Icon(Icons.location_off_rounded, size: 64, color: Color(0xFFF57C00)),
            ),
            const SizedBox(height: 28),
            const Text('Location Disabled', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF212121)), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('Your device location is turned off. Please enable location services to use NearBy Pro fully.', style: TextStyle(color: Color(0xFF757575), fontSize: 15, height: 1.6), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('How to enable:', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF212121))),
                  SizedBox(height: 8),
                  Text('1. Go to Phone Settings\n2. Tap Location\n3. Toggle Location On\n4. Return to this app', style: TextStyle(color: Color(0xFF757575), fontSize: 13, height: 1.7)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Open Location Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            )),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52), side: const BorderSide(color: Color(0xFF0288D1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Search Manually', style: TextStyle(color: Color(0xFF0288D1), fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
