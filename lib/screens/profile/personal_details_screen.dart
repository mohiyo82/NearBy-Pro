import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  
  String? _selectedGender;
  bool _isLoading = false;

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'dob': _dobController.text,
          'gender': _selectedGender,
          'cnic': _cnicController.text.trim(),
          'phone': _phoneController.text.trim(),
          'city': _cityController.text.trim(),
          'address': _addressController.text.trim(),
        });
        
        if (mounted) {
          Navigator.pushNamed(context, '/education-details');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Personal Details'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text('Skip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgress(current: 1, total: 5),
              const SizedBox(height: 28),
              const Text('Your Personal Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 6),
              const Text('Please fill in your details accurately.', style: TextStyle(fontSize: 14, color: AppColors.textGray)),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: _buildField('First Name', 'First name', _firstNameController, (val) => val!.isEmpty ? 'Required' : null),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField('Last Name', 'Last name', _lastNameController, (val) => val!.isEmpty ? 'Required' : null),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildField('Date of Birth', 'Select date', _dobController, (val) => val!.isEmpty ? 'Required' : null, isReadOnly: true, onTap: _selectDate, icon: Icons.calendar_today_outlined),
              const SizedBox(height: 20),
              const Text('Gender', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  prefixIcon: const Icon(Icons.wc_rounded, color: AppColors.textGray),
                ),
                hint: const Text('Select gender'),
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Prefer not to say')),
                ],
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (val) => val == null ? 'Please select gender' : null,
              ),
              const SizedBox(height: 20),
              _buildField('CNIC / National ID', 'XXXXX-XXXXXXX-X', _cnicController, (val) => val!.isEmpty ? 'Required' : null, icon: Icons.badge_outlined),
              const SizedBox(height: 20),
              _buildField('Phone Number', '+92 --- -------', _phoneController, (val) => val!.isEmpty ? 'Required' : null, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildField('Current City', 'Your city', _cityController, (val) => val!.isEmpty ? 'Required' : null, icon: Icons.location_city_outlined),
              const SizedBox(height: 20),
              _buildField('Home Address', 'Street / Area / Sector', _addressController, (val) => val!.isEmpty ? 'Required' : null, icon: Icons.home_outlined),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDetails,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Continue'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text('I\'ll do this later', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, String? Function(String?)? validator, {bool isReadOnly = false, VoidCallback? onTap, IconData? icon, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint, prefixIcon: icon != null ? Icon(icon, color: AppColors.textGray) : null),
          validator: validator,
        ),
      ],
    );
  }
}
