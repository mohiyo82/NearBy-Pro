import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ProfilePreviewScreen extends StatefulWidget {
  const ProfilePreviewScreen({super.key});

  @override
  State<ProfilePreviewScreen> createState() => _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends State<ProfilePreviewScreen> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  // ─── Edit Logic ───
  Future<void> _updateField(String field, String value) async {
    if (user == null) return;
    try {
      await _firestore.collection('users').doc(user!.uid).update({field: value});
      _showSnackBar('Profile updated!');
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _editBasicInfo(Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data['name'] ?? "");
    final bioController = TextEditingController(text: data['bio'] ?? "");
    final phoneController = TextEditingController(text: data['phone'] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Basic Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: 12),
              TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Professional Bio'), maxLines: 3),
              const SizedBox(height: 12),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (user != null) {
                await _firestore.collection('users').doc(user!.uid).update({
                  'name': nameController.text.trim(),
                  'bio': bioController.text.trim(),
                  'phone': phoneController.text.trim(),
                });
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
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
        title: const Text('My Profile'),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/settings'), icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _authService.userDataStream(user?.uid ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Profile not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(data),
                const SizedBox(height: 16),
                _buildQuickActionCards(),
                const SizedBox(height: 24),

                _SectionHeader(title: 'Education', onAdd: () => _showSnackBar('Opening Education Setup...')),
                _buildPlaceholderCard('Add your educational background', Icons.school_outlined),
                
                const SizedBox(height: 24),
                _SectionHeader(title: 'Experience', onAdd: () => _showSnackBar('Opening Experience Setup...')),
                _buildPlaceholderCard('Add your work history', Icons.work_outline),

                const SizedBox(height: 24),
                _SectionHeader(title: 'Skills', onAdd: () => Navigator.pushNamed(context, '/skills-selection')),
                _buildPlaceholderCard('Select your professional skills', Icons.bolt_rounded),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> data) {
    String name = data['name'] ?? "User";
    String bio = data['bio'] ?? "Add a professional summary to attract opportunities...";
    String email = user?.email ?? "";
    String phone = data['phone'] ?? "Add phone number";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarPlaceholder(size: 70, initials: name.substring(0, 1).toUpperCase()),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                        IconButton(onPressed: () => _editBasicInfo(data), icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary)),
                      ],
                    ),
                    Text(bio, style: const TextStyle(fontSize: 13, color: AppColors.textGray), maxLines: 4, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _IconTextRow(icon: Icons.email_outlined, text: email),
          const SizedBox(height: 8),
          _IconTextRow(icon: Icons.phone_outlined, text: phone),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: () => _showSnackBar('Feature coming soon...'), icon: const Icon(Icons.download_rounded, size: 18), label: const Text('Download Resume', style: TextStyle(fontSize: 12)))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: () => _showSnackBar('Privacy set to Public'), icon: const Icon(Icons.public, size: 18), label: const Text('Public Profile', style: TextStyle(fontSize: 11)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards() {
    return Row(
      children: [
        _buildActionCard(Icons.analytics_outlined, 'Analytics', 'View reach', Colors.blue, '/profile-analytics'),
        const SizedBox(width: 12),
        _buildActionCard(Icons.description_outlined, 'Resume', 'Manage files', Colors.orange, '/resume-manager'),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String sub, Color color, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.textLight),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: AppColors.textGray, fontSize: 13, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  const _SectionHeader({required this.title, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          TextButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
        ],
      ),
    );
  }
}

class _IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconTextRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textGray))),
      ],
    );
  }
}
