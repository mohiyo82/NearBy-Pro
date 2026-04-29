import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class ApplyConnectScreen extends StatefulWidget {
  const ApplyConnectScreen({super.key});

  @override
  State<ApplyConnectScreen> createState() => _ApplyConnectScreenState();
}

class _ApplyConnectScreenState extends State<ApplyConnectScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPosition;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();

  bool _isLoading = false;
  bool _isAutoFillEnabled = true;
  bool _useGeneratedResume = true;
  String? _uploadedResumeName;
  Map<String, dynamic>? _userData;
  double _resumeCompletion = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _userData = doc.data();
          _resumeCompletion = _calculateResumeCompletion(_userData);
          if (_isAutoFillEnabled) {
            _nameController.text = _userData?['name'] ?? '';
            _emailController.text = _userData?['email'] ?? '';
            _phoneController.text = _userData?['phone'] ?? '';
            _portfolioController.text = _userData?['portfolioUrl'] ?? '';
          }
        });
      }
    }
  }

  double _calculateResumeCompletion(Map<String, dynamic>? data) {
    if (data == null) return 0.0;
    int filled = 0;
    if (data['name'] != null && data['name'].toString().isNotEmpty) filled++;
    if (data['email'] != null && data['email'].toString().isNotEmpty) filled++;
    if (data['phone'] != null && data['phone'].toString().isNotEmpty) filled++;
    if (data['skills'] != null && (data['skills'] as List).isNotEmpty) filled++;
    if (data['experience'] != null && (data['experience'] as List).isNotEmpty) filled++;
    if (data['education'] != null && (data['education'] as List).isNotEmpty) filled++;
    return (filled / 6).clamp(0.0, 1.0);
  }

  void _toggleAutoFill(bool? value) {
    setState(() {
      _isAutoFillEnabled = value ?? false;
      if (_isAutoFillEnabled && _userData != null) {
        _nameController.text = _userData?['name'] ?? '';
        _emailController.text = _userData?['email'] ?? '';
        _phoneController.text = _userData?['phone'] ?? '';
        _portfolioController.text = _userData?['portfolioUrl'] ?? '';
      }
    });
  }

  Future<void> _submitApplication(Map<String, dynamic> job) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a position')));
      return;
    }

    if (_useGeneratedResume && _resumeCompletion < 0.5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your NearBy Pro Resume is incomplete. Please complete it or upload a custom one.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dbService = Provider.of<DatabaseService>(context, listen: false);

      await dbService.recordApplication({
        'jobId': job['id'] ?? 'unknown',
        'jobTitle': job['title'] ?? 'Position',
        'companyName': job['companyName'] ?? 'Company',
        'appliedPosition': _selectedPosition,
        'applicantName': _nameController.text,
        'applicantEmail': _emailController.text,
        'applicantPhone': _phoneController.text,
        'portfolioUrl': _portfolioController.text,
        'message': _messageController.text,
        'useGeneratedResume': _useGeneratedResume,
        'resumeStatus': _useGeneratedResume ? 'Generated CV' : 'Custom Upload',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/application-success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submission failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {
      'title': 'Job Position',
      'companyName': 'Verified Company',
      'location': 'Lahore, Pakistan',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Apply / Connect'),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJobHeader(job),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Application Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 20),

                    const Text('Position Applying For', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                    const SizedBox(height: 8),
                    _buildPositionDropdown(job['title']),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Personal Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                        Row(
                          children: [
                            const Text('Auto-fill', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                            Switch(
                              value: _isAutoFillEnabled,
                              onChanged: _toggleAutoFill,
                              activeColor: AppColors.primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              scale: 0.8,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInputField('Full Name', _nameController, Icons.person_outline_rounded, validator: (v) => v!.isEmpty ? 'Enter your name' : null),
                    _buildInputField('Email Address', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Enter your email' : null),
                    _buildInputField('Phone Number', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Enter your phone' : null),
                    _buildInputField('Portfolio / LinkedIn (Optional)', _portfolioController, Icons.link_rounded),

                    const SizedBox(height: 24),
                    const Text('Cover Letter / Message', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                    const SizedBox(height: 8),
                    _buildMessageField(),

                    const SizedBox(height: 24),
                    const Text('Attach Resume', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textGray)),
                    const SizedBox(height: 12),
                    _buildResumeSelection(),

                    const SizedBox(height: 32),
                    _buildSubmitButton(job),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobHeader(Map<String, dynamic> job) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF1B4332),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.business_rounded, color: Color(0xFF1B4332), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job['companyName'] ?? 'Software House',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${job['title'] ?? 'Software House'} • ${job['location'] ?? 'Lahore'}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
          hintText: label,
          hintStyle: const TextStyle(fontSize: 14, color: AppColors.textLight),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildPositionDropdown(String? defaultTitle) {
    return DropdownButtonFormField<String>(
      value: _selectedPosition ?? defaultTitle,
      style: const TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.work_outline_rounded, size: 20, color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
      items: [
        DropdownMenuItem(value: defaultTitle, child: Text(defaultTitle ?? 'Select position')),
        const DropdownMenuItem(value: 'Full Stack Developer', child: Text('Full Stack Developer')),
        const DropdownMenuItem(value: 'UI/UX Designer', child: Text('UI/UX Designer')),
        const DropdownMenuItem(value: 'Mobile App Developer', child: Text('Mobile App Developer')),
      ],
      onChanged: (val) => setState(() => _selectedPosition = val),
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      maxLength: 500,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Write a brief message to the employer...',
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textLight),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
    );
  }

  Widget _buildResumeSelection() {
    return Column(
      children: [
        _buildResumeOptionTile(
          title: 'Use NearBy Pro AI Resume',
          subtitle: _resumeCompletion >= 0.8 ? 'Ready to use (High quality)' : 'Completion: ${(_resumeCompletion * 100).toInt()}%',
          icon: Icons.auto_awesome_rounded,
          isSelected: _useGeneratedResume,
          onTap: () => setState(() => _useGeneratedResume = true),
          trailing: _useGeneratedResume ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
        ),
        const SizedBox(height: 12),
        _buildResumeOptionTile(
          title: 'Upload Custom Resume',
          subtitle: _uploadedResumeName ?? 'No file selected (Tap to browse)',
          icon: Icons.upload_file_rounded,
          isSelected: !_useGeneratedResume,
          onTap: () {
            setState(() => _useGeneratedResume = false);
            // Simulate file picking
            setState(() => _uploadedResumeName = 'my_resume_2024.pdf');
          },
          action: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: const Text('Browse', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildResumeOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
    Widget? action,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.03) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[200]!, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? AppColors.primary : AppColors.textDark)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                ],
              ),
            ),
            if (action != null) action,
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Map<String, dynamic> job) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _submitApplication(job),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4332),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading 
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 18),
                  SizedBox(width: 12),
                  Text('Submit Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }
}
