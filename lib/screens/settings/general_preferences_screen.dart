import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';

class GeneralPreferencesScreen extends StatefulWidget {
  const GeneralPreferencesScreen({super.key});

  @override
  State<GeneralPreferencesScreen> createState() => _GeneralPreferencesScreenState();
}

class _GeneralPreferencesScreenState extends State<GeneralPreferencesScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  String _selectedLanguage = 'English';
  String _contentDensity = 'Standard';
  bool _autoPlayVideos = true;
  bool _showMatureContent = false;
  bool _highQualityImages = true;

  final List<String> _languages = ['English', 'Urdu', 'Hindi', 'Arabic', 'French', 'Spanish'];
  final List<String> _densities = ['Compact', 'Standard', 'Relaxed'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    if (_user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
    if (doc.exists && doc.data()!.containsKey('preferences')) {
      final prefs = doc.data()!['preferences'] as Map<String, dynamic>;
      setState(() {
        _selectedLanguage = prefs['language'] ?? 'English';
        _contentDensity = prefs['contentDensity'] ?? 'Standard';
        _autoPlayVideos = prefs['autoPlayVideos'] ?? true;
        _showMatureContent = prefs['showMatureContent'] ?? false;
        _highQualityImages = prefs['highQualityImages'] ?? true;
      });
    }
  }

  Future<void> _savePreference(String key, dynamic value) async {
    if (_user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(_user?.uid).update({
      'preferences.$key': value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('General Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('Content & Language', [
            _buildDropdownTile(
              'App Language', 
              'System default and available languages', 
              _selectedLanguage, 
              _languages,
              (val) {
                setState(() => _selectedLanguage = val!);
                _savePreference('language', val);
              }
            ),
            const Divider(height: 1, indent: 56),
            _buildDropdownTile(
              'Content Density', 
              'Adjust how much content you see at once', 
              _contentDensity, 
              _densities,
              (val) {
                setState(() => _contentDensity = val!);
                _savePreference('contentDensity', val);
              }
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Media Preferences', [
            _buildSwitchTile(
              'Auto-play Videos', 
              'Play videos automatically on Wi-Fi', 
              _autoPlayVideos, 
              (val) {
                setState(() => _autoPlayVideos = val);
                _savePreference('autoPlayVideos', val);
              }
            ),
            const Divider(height: 1, indent: 56),
            _buildSwitchTile(
              'High Quality Images', 
              'Always load high resolution images', 
              _highQualityImages, 
              (val) {
                setState(() => _highQualityImages = val);
                _savePreference('highQualityImages', val);
              }
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Safe Browsing', [
            _buildSwitchTile(
              'Show Mature Content', 
              'Display content potentially not for everyone', 
              _showMatureContent, 
              (val) {
                setState(() => _showMatureContent = val);
                _savePreference('showMatureContent', val);
              }
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textGray)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDropdownTile(String title, String sub, String value, List<String> items, Function(String?) onChanged) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSwitchTile(String title, String sub, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
