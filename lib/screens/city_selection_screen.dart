import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:latlong2/latlong.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? _selectedLocationName;
  LatLng? _selectedLatLng;

  static const List<String> _popular = ['Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta'];
  static const List<String> _all = ['Abbottabad', 'Bahawalpur', 'Gujranwala', 'Gujrat', 'Hyderabad', 'Jhang', 'Larkana', 'Mardan', 'Mingora', 'Mirpur', 'Nawabshah', 'Okara', 'Sahiwal', 'Sargodha', 'Sheikhupura', 'Sialkot', 'Sukkur'];

  Future<void> _pickLocationFromMap() async {
    // Navigator.pushNamed returns the result from the pushed route
    final result = await Navigator.pushNamed(context, '/map-picker');

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedLocationName = result['address'];
        _selectedLatLng = result['position'];
      });
      
      // Auto-save and move forward or show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location Selected: ${_selectedLocationName?.split(',').first}'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select City'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search your city...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGray),
              ),
            ),
          ),

          // Selected Location Display (If any)
          if (_selectedLocationName != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Current Selection', style: TextStyle(fontSize: 11, color: AppColors.textGray, fontWeight: FontWeight.bold)),
                        Text(_selectedLocationName!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedLocationName = null),
                    child: const Text('Clear', style: TextStyle(color: Colors.red, fontSize: 12)),
                  )
                ],
              ),
            ),

          // Use Current Location Button
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 20),
            ),
            title: const Text('Use My Current Location', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
            subtitle: const Text('Detect automatically using Map', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            onTap: _pickLocationFromMap,
          ),
          
          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Popular Cities', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _popular.map((c) => GestureDetector(
                    onTap: () {
                      setState(() => _selectedLocationName = c);
                      Navigator.pop(context); // Or handle as per flow
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.location_city_rounded, size: 15, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(c, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ]),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 24),
                const Text('All Cities', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textGray, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                ..._all.map((c) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined, color: AppColors.textGray),
                  title: Text(c, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textDark)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
                  onTap: () {
                    setState(() => _selectedLocationName = c);
                    Navigator.pop(context);
                  },
                )),
              ],
            ),
          ),
          
          // Continue Button (Shows only if location is selected)
          if (_selectedLocationName != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Save logic here (e.g. update Provider/State)
                    Navigator.pop(context, {'name': _selectedLocationName, 'latlng': _selectedLatLng});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Continue with this Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
