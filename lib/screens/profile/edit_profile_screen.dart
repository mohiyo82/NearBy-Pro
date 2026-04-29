import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/cloudinary_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/phone_input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _cloudinaryService = CloudinaryService();
  bool _isLoading = false;
  String _loadingMessage = "Saving profile...";
  final _formKey = GlobalKey<FormState>();

  // Controllers for basic info
  final _fNameC = TextEditingController();
  final _lNameC = TextEditingController();
  final _titleC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _bioC = TextEditingController();
  
  // Link Controllers
  final _linkedinC = TextEditingController();
  final _githubC = TextEditingController();
  final _websiteC = TextEditingController();

  // Dynamic data lists
  List<Map<String, dynamic>> _education = [];
  List<Map<String, dynamic>> _experience = [];
  List<Map<String, dynamic>> _certificates = [];

  String? _photoUrl;
  File? _imageFile;
  String _selectedCountryCode = '+92';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (user == null) return;
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final d = doc.data()!;
        setState(() {
          _fNameC.text = d['firstName'] ?? d['name'] ?? '';
          _lNameC.text = d['lastName'] ?? '';
          _titleC.text = d['title'] ?? '';
          _emailC.text = d['email'] ?? user!.email ?? '';
          
          String phone = d['phone'] ?? '';
          if (phone.startsWith('+92')) {
            _selectedCountryCode = '+92';
            _phoneC.text = phone.substring(3);
          } else if (phone.startsWith('+1')) {
            _selectedCountryCode = '+1';
            _phoneC.text = phone.substring(2);
          } else {
             _phoneC.text = phone;
          }

          _bioC.text = d['bio'] ?? '';
          
          _linkedinC.text = d['linkedin'] ?? '';
          _githubC.text = d['github'] ?? '';
          _websiteC.text = d['website'] ?? '';

          _photoUrl = d['photoUrl'];

          _education = List<Map<String, dynamic>>.from(d['education'] ?? []);
          _experience = List<Map<String, dynamic>>.from(d['experience'] ?? []);
          _certificates = List<Map<String, dynamic>>.from(d['certificates'] ?? []);
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, 
        imageQuality: 50,
        maxWidth: 500,
        maxHeight: 500,
      );
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) return;
    
    setState(() {
      _isLoading = true;
      _loadingMessage = _imageFile != null ? "Uploading Image to Cloudinary..." : "Saving Profile...";
    });

    try {
      String? finalPhotoUrl = _photoUrl;
      
      // Upload to Cloudinary if a new image was picked
      if (_imageFile != null) {
        final String? uploadedUrl = await _cloudinaryService.uploadImage(_imageFile!);
        if (uploadedUrl != null) {
          finalPhotoUrl = uploadedUrl;
        } else {
          throw Exception("Cloudinary upload failed. Check internet connection.");
        }
      }

      setState(() => _loadingMessage = "Saving Data to Firebase...");

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'firstName': _fNameC.text.trim(),
        'lastName': _lNameC.text.trim(),
        'name': '${_fNameC.text.trim()} ${_lNameC.text.trim()}',
        'title': _titleC.text.trim(),
        'email': _emailC.text.trim(),
        'phone': '$_selectedCountryCode${_phoneC.text.trim()}',
        'bio': _bioC.text.trim(),
        'linkedin': _linkedinC.text.trim(),
        'github': _githubC.text.trim(),
        'website': _websiteC.text.trim(),
        'photoUrl': finalPhotoUrl,
        'education': _education,
        'experience': _experience,
        'certificates': _certificates,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Color(0xFF1B4332)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Edit Professional Profile', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveData,
            child: const Text('SAVE', style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Color(0xFF1B4332)),
                const SizedBox(height: 16),
                Text(_loadingMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoSection(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('Basic Information'),
                    _buildBasicInfoCard(),
                    const SizedBox(height: 20),
                    
                    _buildSectionHeader('Professional Summary'),
                    _buildBioCard(),
                    const SizedBox(height: 20),
                
                    _buildDynamicSection(
                      title: 'Education',
                      items: _education,
                      onAdd: () => _showEducationModal(),
                      onEdit: (item, index) => _showEducationModal(item: item, index: index),
                      onDelete: (index) => setState(() => _education.removeAt(index)),
                      itemTitleBuilder: (item) => item['degree'] ?? '',
                      itemSubTitleBuilder: (item) => '${item['institution'] ?? ''} (${item['startDate'] ?? ''} - ${item['endDate'] ?? 'Present'})',
                    ),
                    const SizedBox(height: 20),
                
                    _buildDynamicSection(
                      title: 'Work Experience',
                      items: _experience,
                      onAdd: () => _showExperienceModal(),
                      onEdit: (item, index) => _showExperienceModal(item: item, index: index),
                      onDelete: (index) => setState(() => _experience.removeAt(index)),
                      itemTitleBuilder: (item) => item['jobTitle'] ?? '',
                      itemSubTitleBuilder: (item) => '${item['companyName'] ?? ''} (${item['startDate'] ?? ''} - ${item['endDate'] ?? 'Present'})',
                    ),
                    const SizedBox(height: 20),
                
                    _buildDynamicSection(
                      title: 'Certificates',
                      items: _certificates,
                      onAdd: () => _showCertificateModal(),
                      onEdit: (item, index) => _showCertificateModal(item: item, index: index),
                      onDelete: (index) => setState(() => _certificates.removeAt(index)),
                      itemTitleBuilder: (item) => item['name'] ?? '',
                      itemSubTitleBuilder: (item) => item['organization'] ?? '',
                    ),
                    const SizedBox(height: 20),
                    
                    _buildSectionHeader('Social & Portfolio Links'),
                    _buildLinksCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPhotoSection() {
    ImageProvider? bgImage;
    if (_imageFile != null) {
      bgImage = FileImage(_imageFile!);
    } else if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      bgImage = NetworkImage(_photoUrl!);
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE5E7EB),
            backgroundImage: bgImage,
            child: bgImage == null
                ? const Icon(Icons.person, size: 50, color: Color(0xFF9CA3AF))
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFF1B4332), shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildTextField(_fNameC, 'First Name', validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          _buildTextField(_lNameC, 'Last Name', validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          _buildTextField(_titleC, 'Professional Title (e.g. Software Engineer)', validator: (v) => v!.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          PhoneInputField(
            controller: _phoneC,
            onCountryChanged: (c) => setState(() => _selectedCountryCode = c.code),
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: _buildTextField(_bioC, 'Tell us about your professional journey...', maxLines: 5, validator: (v) => v!.isEmpty ? 'Required' : null),
    );
  }

  Widget _buildLinksCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildTextField(_linkedinC, 'LinkedIn Profile URL', prefixIcon: Icons.link, validator: (v) {
            if (v!.isNotEmpty && !v.contains('linkedin.com')) return 'Invalid LinkedIn URL';
            return null;
          }),
          const SizedBox(height: 12),
          _buildTextField(_githubC, 'GitHub Portfolio URL', prefixIcon: Icons.code, validator: (v) {
            if (v!.isNotEmpty && !v.contains('github.com')) return 'Invalid GitHub URL';
            return null;
          }),
          const SizedBox(height: 12),
          _buildTextField(_websiteC, 'Personal Website URL', prefixIcon: Icons.language),
        ],
      ),
    );
  }

  Widget _buildDynamicSection({
    required String title,
    required List<Map<String, dynamic>> items,
    required VoidCallback onAdd,
    required Function(Map<String, dynamic>, int) onEdit,
    required Function(int) onDelete,
    required String Function(Map<String, dynamic>) itemTitleBuilder,
    required String Function(Map<String, dynamic>) itemSubTitleBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(title),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18, color: Color(0xFF1B4332)),
              label: const Text('Add', style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: const Text('No entries added yet.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9CA3AF))),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
                child: ListTile(
                  title: Text(itemTitleBuilder(item), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(itemSubTitleBuilder(item)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => onEdit(item, index)),
                      IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () => onDelete(index)),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, IconData? prefixIcon, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20, color: const Color(0xFF1B4332)) : null,
        labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B4332), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // --- MODALS ---

  void _showEducationModal({Map<String, dynamic>? item, int? index}) {
    final degreeC = TextEditingController(text: item?['degree'] ?? '');
    final instC = TextEditingController(text: item?['institution'] ?? '');
    final startC = TextEditingController(text: item?['startDate'] ?? '');
    final endC = TextEditingController(text: item?['endDate'] ?? '');
    final modalFormKey = GlobalKey<FormState>();

    _showFormModal(
      title: index == null ? 'Add Education' : 'Edit Education',
      formKey: modalFormKey,
      children: [
        _buildTextField(degreeC, 'Degree / Certification', validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        _buildTextField(instC, 'Institution Name', validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField(startC, 'Start Year (e.g. 2020)', keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(endC, 'End Year (e.g. 2024)', keyboardType: TextInputType.number)),
          ],
        ),
      ],
      onSave: () {
        if (modalFormKey.currentState!.validate()) {
          final data = {'degree': degreeC.text, 'institution': instC.text, 'startDate': startC.text, 'endDate': endC.text};
          setState(() {
            if (index == null) _education.add(data);
            else _education[index] = data;
          });
          Navigator.pop(context);
        }
      },
    );
  }

  void _showExperienceModal({Map<String, dynamic>? item, int? index}) {
    final titleC = TextEditingController(text: item?['jobTitle'] ?? '');
    final companyC = TextEditingController(text: item?['companyName'] ?? '');
    final startC = TextEditingController(text: item?['startDate'] ?? '');
    final endC = TextEditingController(text: item?['endDate'] ?? '');
    final descC = TextEditingController(text: item?['description'] ?? '');
    final modalFormKey = GlobalKey<FormState>();

    _showFormModal(
      title: index == null ? 'Add Experience' : 'Edit Experience',
      formKey: modalFormKey,
      children: [
        _buildTextField(titleC, 'Job Title', validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        _buildTextField(companyC, 'Company Name', validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTextField(startC, 'Start Year (e.g. 2022)', keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(endC, 'End Year (e.g. Present)', keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: 12),
        _buildTextField(descC, 'Description', maxLines: 3),
      ],
      onSave: () {
        if (modalFormKey.currentState!.validate()) {
          final data = {'jobTitle': titleC.text, 'companyName': companyC.text, 'startDate': startC.text, 'endDate': endC.text, 'description': descC.text};
          setState(() {
            if (index == null) _experience.add(data);
            else _experience[index] = data;
          });
          Navigator.pop(context);
        }
      },
    );
  }

  void _showCertificateModal({Map<String, dynamic>? item, int? index}) {
    final nameC = TextEditingController(text: item?['name'] ?? '');
    final orgC = TextEditingController(text: item?['organization'] ?? '');
    final modalFormKey = GlobalKey<FormState>();

    _showFormModal(
      title: index == null ? 'Add Certificate' : 'Edit Certificate',
      formKey: modalFormKey,
      children: [
        _buildTextField(nameC, 'Certificate Name', validator: (v) => v!.isEmpty ? 'Required' : null),
        const SizedBox(height: 12),
        _buildTextField(orgC, 'Issuing Organization', validator: (v) => v!.isEmpty ? 'Required' : null),
      ],
      onSave: () {
        if (modalFormKey.currentState!.validate()) {
          final data = {'name': nameC.text, 'organization': orgC.text};
          setState(() {
            if (index == null) _certificates.add(data);
            else _certificates[index] = data;
          });
          Navigator.pop(context);
        }
      },
    );
  }

  void _showFormModal({required String title, required List<Widget> children, required VoidCallback onSave, required GlobalKey<FormState> formKey}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(height: 30),
                ...children,
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4332), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Save Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
