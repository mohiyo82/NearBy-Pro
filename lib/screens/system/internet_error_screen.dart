import 'package:flutter/material.dart';

class InternetErrorScreen extends StatelessWidget {
  const InternetErrorScreen({super.key});

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
              decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded, size: 64, color: Color(0xFFE53935)),
            ),
            const SizedBox(height: 28),
            const Text('No Internet Connection', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF212121)), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('It seems you\'re offline. Please check your WiFi or mobile data connection and try again.', style: TextStyle(color: Color(0xFF757575), fontSize: 15, height: 1.6), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 54, child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text('Try Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            )),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52), side: const BorderSide(color: Color(0xFF0288D1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Open Network Settings', style: TextStyle(color: Color(0xFF0288D1), fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
