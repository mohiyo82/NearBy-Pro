import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _regNumC = TextEditingController();
  final _industryC = TextEditingController();
  final _locationC = TextEditingController();
  final _websiteC = TextEditingController();
  final _authPersonNameC = TextEditingController();
  final _authPersonCnicC = TextEditingController();
  
  PlatformFile? _certificateFile;
  PlatformFile? _cnicFile;
  bool _isLoading = false;
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<void> _pickFile(bool isCertificate) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        if (isCertificate) {
          _certificateFile = result.files.first;
        } else {
          _cnicFile = result.files.first;
        }
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (_certificateFile == null || _cnicFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required documents')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Saving company registration details to Firestore
      await FirebaseFirestore.instance.collection('company_registrations').add({
        'userId': _user?.uid,
        'companyName': _nameC.text.trim(),
        'registrationNumber': _regNumC.text.trim(),
        'industry': _industryC.text.trim(),
        'location': _locationC.text.trim(),
        'website': _websiteC.text.trim(),
        'authorizedPerson': _authPersonNameC.text.trim(),
        'authorizedPersonCnic': _authPersonCnicC.text.trim(),
        'certificateName': _certificateFile!.name,
        'cnicCopyName': _cnicFile!.name,
        'status': 'pending', 
        'submittedAt': FieldValue.serverTimestamp(),
      });

      // Update user profile
      await FirebaseFirestore.instance.collection('users').doc(_user?.uid).update({
        'hasCompanyRegistration': true,
        'companyStatus': 'pending',
        'tempCompanyName': _nameC.text.trim(),
      });

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Application Submitted'),
        content: const Text(
          'Your company registration and documents (Certificate & CNIC) are under review. Once verified, you can toggle to Company Mode and post jobs.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Back to Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Register Company', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Company Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildField('Company Name', _nameC, Icons.business_rounded),
              const SizedBox(height: 16),
              _buildField('Registration Number (NTN/FTN)', _regNumC, Icons.assignment_ind_rounded),
              const SizedBox(height: 16),
              _buildField('Industry', _industryC, Icons.category_rounded),
              const SizedBox(height: 16),
              _buildField('Headquarters Location', _locationC, Icons.location_on_rounded),
              const SizedBox(height: 16),
              _buildField('Website URL', _websiteC, Icons.language_rounded, kb: TextInputType.url),
              
              const SizedBox(height: 32),
              const Text('Authorized Person Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildField('Authorized Person Name', _authPersonNameC, Icons.person_rounded),
              const SizedBox(height: 16),
              _buildField(
                'Authorized Person CNIC', 
                _authPersonCnicC, 
                Icons.badge_rounded, 
                kb: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                hint: '13-digit CNIC without dashes'
              ),
              
              const SizedBox(height: 32),
              const Text('Verification Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              _buildUploadSection(
                'Company Registration Certificate',
                _certificateFile,
                () => _pickFile(true),
              ),
              const SizedBox(height: 16),
              _buildUploadSection(
                'Authorized Person CNIC Copy',
                _cnicFile,
                () => _pickFile(false),
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit for Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(String title, PlatformFile? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  file == null ? Icons.file_upload_outlined : Icons.check_circle_rounded,
                  color: file == null ? AppColors.textGray : Colors.green,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file == null ? 'Upload PDF or Image' : file.name,
                    style: TextStyle(
                      color: file == null ? AppColors.textGray : AppColors.textDark,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
                if (file != null) const Icon(Icons.edit, size: 16, color: AppColors.textGray),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {TextInputType kb = TextInputType.text, List<TextInputFormatter>? formatters, String? hint}) {
    return TextFormField(
      controller: controller,
      keyboardType: kb,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1B4332), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B4332))),
      ),
      validator: (v) => v == null || v.isEmpty ? 'This field is required' : null,
    );
  }
}
