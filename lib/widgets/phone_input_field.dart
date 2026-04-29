import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class Country {
  final String name;
  final String code;
  final String flag;
  final int maxLength;

  const Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.maxLength,
  });
}

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Function(Country)? onCountryChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.label = 'Phone Number',
    this.onCountryChanged,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  static const List<Country> countries = [
    Country(name: 'Pakistan', code: '+92', flag: '🇵🇰', maxLength: 10),
    Country(name: 'United States', code: '+1', flag: '🇺🇸', maxLength: 10),
    Country(name: 'United Kingdom', code: '+44', flag: '🇬🇧', maxLength: 10),
    Country(name: 'Saudi Arabia', code: '+966', flag: '🇸🇦', maxLength: 9),
    Country(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪', maxLength: 9),
    Country(name: 'India', code: '+91', flag: '🇮🇳', maxLength: 10),
  ];

  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = countries.firstWhere((c) => c.code == '+92');
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Country', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return ListTile(
                    leading: Text(country.flag, style: const TextStyle(fontSize: 24)),
                    title: Text(country.name),
                    trailing: Text(country.code, 
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      setState(() {
                        _selectedCountry = country;
                        widget.controller.clear();
                      });
                      if (widget.onCountryChanged != null) {
                        widget.onCountryChanged!(country);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, 
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(_selectedCountry.maxLength),
          ],
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            prefixIcon: GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.border, width: 1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    Text(_selectedCountry.code, 
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const Icon(Icons.arrow_drop_down, color: AppColors.textGray),
                  ],
                ),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (value.length < _selectedCountry.maxLength - 1) {
              return 'Enter a valid number for ${_selectedCountry.name}';
            }
            return null;
          },
        ),
      ],
    );
  }
}
