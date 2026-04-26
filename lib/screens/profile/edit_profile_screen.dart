import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  // Controllers
  final _fNameC = TextEditingController();
  final _lNameC = TextEditingController();
  final _titleC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _addressC = TextEditingController();
  final _bioC = TextEditingController();

  // Additional Information State
  String _infoType = 'Diploma';
  List<String> _technicalSkills = ['JavaScript', 'Python', 'Flutter', 'Firebase', 'Figma'];
  String _urduProficiency = 'Native';
  String _englishProficiency = 'Fluent';
  final _infoNameC = TextEditingController();
  final _descC = TextEditingController();

  // Dynamic Lists
  List<Map<String, dynamic>> _experience = [];
  List<Map<String, dynamic>> _education = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (user == null) return;
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final d = doc.data()!;
        setState(() {
          _fNameC.text = d['firstName'] ?? '';
          _lNameC.text = d['lastName'] ?? '';
          _titleC.text = d['title'] ?? '';
          _emailC.text = d['email'] ?? user!.email ?? '';
          _phoneC.text = d['phone'] ?? '';
          _addressC.text = d['address'] ?? '';
          _bioC.text = d['bio'] ?? '';
          _experience = List<Map<String, dynamic>>.from(d['experience'] ?? []);
          _education = List<Map<String, dynamic>>.from(d['education'] ?? []);
          _infoType = d['infoType'] ?? 'Diploma';
          _urduProficiency = d['urduProficiency'] ?? 'Native';
          _englishProficiency = d['englishProficiency'] ?? 'Fluent';
          _infoNameC.text = d['infoName'] ?? '';
          _descC.text = d['infoDesc'] ?? '';
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAddInfoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildModalHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add any additional information that strengthens your profile.', style: TextStyle(color: AppColors.textGray, fontSize: 13)),
                      const SizedBox(height: 20),
                      _sectionLabel('Additional Information Type *'),
                      _buildInfoTypeGrid(setModalState),
                      const SizedBox(height: 24),
                      _sectionLabel('Technical Skills'),
                      _buildSkillChips(setModalState),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: _buildDropdown('Urdu Proficiency', _urduProficiency, ['Native', 'Fluent', 'Intermediate'], (v) => setModalState(() => _urduProficiency = v!))),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDropdown('English Proficiency', _englishProficiency, ['Native', 'Fluent', 'Intermediate'], (v) => setModalState(() => _englishProficiency = v!))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _sectionLabel('Name *'),
                      _modalTF(_infoNameC, 'Enter name/title'),
                      const SizedBox(height: 24),
                      _sectionLabel('Description'),
                      _modalTF(_descC, 'Enter details...', maxLines: 4),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D40)),
                        child: const Text('Save Details'),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Professional CV Builder', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white, elevation: 1, iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Personal Details'),
              _tf(_fNameC, 'First Name*'),
              _tf(_lNameC, 'Last Name*'),
              _tf(_titleC, 'Job Title*'),
              const SizedBox(height: 24),
              
              _header('Additional Information', _showAddInfoModal),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: $_infoType', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Skills: ${_technicalSkills.take(3).join(', ')}...'),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              SizedBox(width: double.infinity, height: 55, child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D3E4E)),
                child: const Text('SAVE & GENERATE CV'),
              )),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modal Helpers ---

  Widget _buildModalHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add Additional Information Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 20)),
        ],
      ),
    );
  }

  Widget _buildInfoTypeGrid(StateSetter setModalState) {
    final types = ['Diploma', 'Professional Certification', 'Extracurricular Activities', 'Honors & Awards', 'Sports', 'Projects', 'Publications', 'Trainings & Workshops', 'Debates'];
    return Wrap(
      spacing: 10, runSpacing: 10,
      children: types.map((t) => GestureDetector(
        onTap: () => setModalState(() => _infoType = t),
        child: Container(
          width: (MediaQuery.of(context).size.width - 60) / 2,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _infoType == t ? AppColors.primary : AppColors.border, width: _infoType == t ? 1.5 : 1),
          ),
          child: Row(children: [
            Icon(_infoType == t ? Icons.radio_button_checked : Icons.radio_button_off, size: 16, color: _infoType == t ? AppColors.primary : AppColors.textGray),
            const SizedBox(width: 8),
            Expanded(child: Text(t, style: const TextStyle(fontSize: 12))),
          ]),
        ),
      )).toList(),
    );
  }

  Widget _buildSkillChips(StateSetter setModalState) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: _technicalSkills.map((s) => Chip(
        label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 11)),
        backgroundColor: const Color(0xFF3F51B5),
        deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
        onDeleted: () => setModalState(() => _technicalSkills.remove(s)),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      )).toList(),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onCh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        DropdownButtonFormField<String>(
          value: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onCh, decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
        ),
      ],
    );
  }

  // --- Common UI Components ---
  Widget _sectionLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)));
  Widget _header(String t, VoidCallback o) => Row(children: [Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), const Spacer(), IconButton(onPressed: o, icon: const Icon(Icons.add_circle, color: AppColors.primary))]);
  Widget _tf(TextEditingController c, String h) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(controller: c, decoration: InputDecoration(labelText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))));
  Widget _modalTF(TextEditingController c, String h, {int maxLines = 1}) => TextField(controller: c, maxLines: maxLines, decoration: InputDecoration(hintText: h, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))));
}
