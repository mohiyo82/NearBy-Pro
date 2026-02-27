import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

// ─── Data Models ───
class UserProfile {
  String name = "";
  String bio = "";
  String email = "";
  String address = "";
  String? profilePicture; // This will store the file path of the image
  String privacyLevel = "Public"; 
  List<EducationItem> education = [];
  List<ExperienceItem> experience = [];
  List<ProjectItem> projects = [];
  List<CertificateItem> certificates = [];
  List<String> portfolioLinks = [];
  bool hasResume = false;

  UserProfile({
    required this.name,
    required this.bio,
    required this.email,
    required this.address,
    this.profilePicture,
    this.privacyLevel = "Public",
    this.hasResume = false,
  });

  double get basicInfoProgress {
    int filled = 0;
    if (name.trim().isNotEmpty) filled++;
    if (bio.trim().isNotEmpty) filled++;
    if (email.trim().isNotEmpty) filled++;
    if (address.trim().isNotEmpty) filled++;
    return filled / 4.0;
  }

  double get educationProgress => education.isNotEmpty ? 1.0 : 0.0;
  double get experienceProgress => experience.isNotEmpty ? 1.0 : 0.0;
  double get projectsProgress => projects.isNotEmpty ? 1.0 : 0.0;
  double get pictureProgress => (profilePicture != null && profilePicture!.isNotEmpty) ? 1.0 : 0.0;

  double get completeness {
    return (basicInfoProgress + educationProgress + experienceProgress + projectsProgress + pictureProgress) / 5.0;
  }
}

class EducationItem {
  String degree;
  String institution;
  String location;
  String period;
  EducationItem(this.degree, this.institution, this.location, this.period);
}

class ExperienceItem {
  String title;
  String company;
  String location;
  String period;
  String description;
  ExperienceItem(this.title, this.company, this.location, this.period, this.description);
}

class ProjectItem {
  String title;
  String category;
  String description;
  ProjectItem(this.title, this.category, this.description);
}

class CertificateItem {
  String title;
  String organization;
  String date;
  CertificateItem(this.title, this.organization, this.date);
}

class ProfilePreviewScreen extends StatefulWidget {
  const ProfilePreviewScreen({super.key});

  @override
  State<ProfilePreviewScreen> createState() => _ProfilePreviewScreenState();
}

class _ProfilePreviewScreenState extends State<ProfilePreviewScreen> {
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = UserProfile(
      name: 'Mohiyo Din Attari',
      bio: 'I am Mohiyo Din, a passionate and motivated Software Engineering student at Superior University, Lahore. I am actively developing my skills in full stack development...',
      email: 'mohiyodin27@gmail.com',
      address: 'Home number 96, 48 block, DG khan',
    );
    _profile.education.add(EducationItem('Software Engineering', 'Superior university Gold Campus', 'Pakistan', '2023-10-13 - Present'));
    _profile.experience.add(ExperienceItem('Software Engineer', 'Repair Desk', 'Pakistan | Internship | On-site', '2025-06-12 - 2025-08-31', 'Served as a Full Stack Web Development Intern at RepairDesk...'));
    _profile.projects.add(ProjectItem('E commerce Marketplace', 'Projects', 'Use & Sell is a fully functional e-commerce marketplace web application developed to provide a secure and user-friendly platform for buying and selling products online.'));
    _profile.certificates.add(CertificateItem('Software Engineer', 'Repair Desk', '2025-08-26'));
    _profile.portfolioLinks.add('https://www.linkedin.com/in/mohiyo-din-9442a42b3');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  // ─── Profile Picture logic ───
  void _editProfilePicture() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Profile Picture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(Icons.camera_alt_rounded, 'Camera', () {
                  Navigator.pop(context);
                  _mockImagePicker('Camera');
                }),
                _buildImageOption(Icons.photo_library_rounded, 'Gallery', () {
                  Navigator.pop(context);
                  _mockImagePicker('Gallery');
                }),
                if (_profile.profilePicture != null)
                  _buildImageOption(Icons.delete_outline_rounded, 'Remove', () {
                    setState(() => _profile.profilePicture = null);
                    Navigator.pop(context);
                    _showSnackBar('Profile picture removed');
                  }, color: Colors.red),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: (color ?? AppColors.primary).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color ?? AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color ?? AppColors.textDark)),
        ],
      ),
    );
  }

  // This simulates picking an image since we don't have image_picker package added in pubspec yet
  void _mockImagePicker(String source) {
    _showSnackBar('Opening $source...');
    // Simulating a selection after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _profile.profilePicture = "mock_path_to_image.jpg"; // Set mock path
        });
        _showSnackBar('Profile picture updated!');
      }
    });
  }

  // ─── Other Edit Dialogs ───
  void _editBasicInfo() {
    final nameController = TextEditingController(text: _profile.name);
    final bioController = TextEditingController(text: _profile.bio);
    final emailController = TextEditingController(text: _profile.email);
    final addressController = TextEditingController(text: _profile.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Basic Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Bio'), maxLines: 3),
              const SizedBox(height: 12),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 12),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _profile.name = nameController.text;
                _profile.bio = bioController.text;
                _profile.email = emailController.text;
                _profile.address = addressController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption('Public', 'Anyone can see your profile'),
            _buildRadioOption('Private', 'Only you can see your profile'),
            _buildRadioOption('Organizations', 'Only registered companies can view you'),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value, String subtitle) {
    return RadioListTile<String>(
      title: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      groupValue: _profile.privacyLevel,
      activeColor: AppColors.primary,
      onChanged: (val) {
        setState(() => _profile.privacyLevel = val!);
        Navigator.pop(context);
        _showSnackBar('Privacy set to $val');
      },
    );
  }

  void _editEducation(int? index) {
    final item = index != null ? _profile.education[index] : null;
    final degreeCtrl = TextEditingController(text: item?.degree);
    final instCtrl = TextEditingController(text: item?.institution);
    final locCtrl = TextEditingController(text: item?.location);
    final periodCtrl = TextEditingController(text: item?.period);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Education' : 'Edit Education'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: degreeCtrl, decoration: const InputDecoration(labelText: 'Degree')),
              const SizedBox(height: 12),
              TextField(controller: instCtrl, decoration: const InputDecoration(labelText: 'Institution')),
              const SizedBox(height: 12),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location')),
              const SizedBox(height: 12),
              TextField(controller: periodCtrl, decoration: const InputDecoration(labelText: 'Period')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final newItem = EducationItem(degreeCtrl.text, instCtrl.text, locCtrl.text, periodCtrl.text);
                if (index == null) {
                  _profile.education.add(newItem);
                } else {
                  _profile.education[index] = newItem;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editExperience(int? index) {
    final item = index != null ? _profile.experience[index] : null;
    final titleCtrl = TextEditingController(text: item?.title);
    final compCtrl = TextEditingController(text: item?.company);
    final locCtrl = TextEditingController(text: item?.location);
    final periodCtrl = TextEditingController(text: item?.period);
    final descCtrl = TextEditingController(text: item?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Experience' : 'Edit Experience'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Job Title')),
              const SizedBox(height: 12),
              TextField(controller: compCtrl, decoration: const InputDecoration(labelText: 'Company')),
              const SizedBox(height: 12),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location')),
              const SizedBox(height: 12),
              TextField(controller: periodCtrl, decoration: const InputDecoration(labelText: 'Period')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final newItem = ExperienceItem(titleCtrl.text, compCtrl.text, locCtrl.text, periodCtrl.text, descCtrl.text);
                if (index == null) {
                  _profile.experience.add(newItem);
                } else {
                  _profile.experience[index] = newItem;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editProject(int? index) {
    final item = index != null ? _profile.projects[index] : null;
    final titleCtrl = TextEditingController(text: item?.title);
    final catCtrl = TextEditingController(text: item?.category);
    final descCtrl = TextEditingController(text: item?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Project' : 'Edit Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Project Title')),
              const SizedBox(height: 12),
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Category')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final newItem = ProjectItem(titleCtrl.text, catCtrl.text, descCtrl.text);
                if (index == null) {
                  _profile.projects.add(newItem);
                } else {
                  _profile.projects[index] = newItem;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editCertificate(int? index) {
    final item = index != null ? _profile.certificates[index] : null;
    final titleCtrl = TextEditingController(text: item?.title);
    final orgCtrl = TextEditingController(text: item?.organization);
    final dateCtrl = TextEditingController(text: item?.date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Certificate' : 'Edit Certificate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Certificate Title')),
            const SizedBox(height: 12),
            TextField(controller: orgCtrl, decoration: const InputDecoration(labelText: 'Organization')),
            const SizedBox(height: 12),
            TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Issue Date')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final newItem = CertificateItem(titleCtrl.text, orgCtrl.text, dateCtrl.text);
                if (index == null) {
                  _profile.certificates.add(newItem);
                } else {
                  _profile.certificates[index] = newItem;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addPortfolioLink() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Portfolio Link'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'https://...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                setState(() => _profile.portfolioLinks.add(ctrl.text));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalProgress = _profile.completeness;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/settings'), icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildResumeGenerator(),
            const SizedBox(height: 16),
            _buildProfileCompleteness(totalProgress),
            const SizedBox(height: 16),
            _buildProfileMilestones(totalProgress),
            const SizedBox(height: 24),

            _SectionHeader(title: 'Education', onAdd: () => _editEducation(null)),
            if (_profile.education.isEmpty)
              _buildEmptyPlaceholder('No education details added')
            else
              ..._profile.education.asMap().entries.map((e) => _buildContentCard(
                title: e.value.degree,
                subtitle: e.value.institution,
                details: [e.value.location, e.value.period],
                icon: Icons.school_outlined,
                onEdit: () => _editEducation(e.key),
                onDelete: () => setState(() => _profile.education.removeAt(e.key)),
              )),
            const SizedBox(height: 24),

            _SectionHeader(title: 'Experience', onAdd: () => _editExperience(null)),
            if (_profile.experience.isEmpty)
              _buildEmptyPlaceholder('No work experience added')
            else
              ..._profile.experience.asMap().entries.map((e) => _buildContentCard(
                title: e.value.title,
                subtitle: e.value.company,
                details: [e.value.location, e.value.period],
                description: e.value.description,
                icon: Icons.work_outline,
                onEdit: () => _editExperience(e.key),
                onDelete: () => setState(() => _profile.experience.removeAt(e.key)),
              )),
            const SizedBox(height: 24),

            _SectionHeader(title: 'Additional Information', onAdd: () => _editProject(null)),
            if (_profile.projects.isEmpty)
              _buildEmptyPlaceholder('No additional info added')
            else
              ..._profile.projects.asMap().entries.map((e) => _buildContentCard(
                title: e.value.title,
                subtitle: e.value.category,
                description: e.value.description,
                icon: Icons.lightbulb_outline,
                onEdit: () => _editProject(e.key),
                onDelete: () => setState(() => _profile.projects.removeAt(e.key)),
              )),
            const SizedBox(height: 24),

            _SectionHeader(title: 'Certificates', onAdd: () => _editCertificate(null)),
            if (_profile.certificates.isEmpty)
              _buildEmptyPlaceholder('No certificates added')
            else
              ..._profile.certificates.asMap().entries.map((e) => _buildContentCard(
                title: e.value.title,
                subtitle: 'Issuing Organization: ${e.value.organization}',
                details: ['Issue Date: ${e.value.date}'],
                icon: Icons.verified_user_outlined,
                onEdit: () => _editCertificate(e.key),
                onDelete: () => setState(() => _profile.certificates.removeAt(e.key)),
              )),
            const SizedBox(height: 24),

            _SectionHeader(title: 'Portfolio', onAdd: _addPortfolioLink, addLabel: 'Edit Portfolio'),
            _buildPortfolioSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    bool hasName = _profile.name.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Interactive Avatar ───
              GestureDetector(
                onTap: _editProfilePicture,
                child: Stack(
                  children: [
                    _profile.profilePicture != null
                        ? Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface),
                            child: ClipOval(child: Image.network("https://via.placeholder.com/150", fit: BoxFit.cover)), // Mock image
                          )
                        : AvatarPlaceholder(size: 70, initials: hasName ? _profile.name.substring(0, 2).toUpperCase() : 'U'),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(hasName ? _profile.name : 'Add Your Name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                        IconButton(onPressed: _editBasicInfo, icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary)),
                      ],
                    ),
                    Text(_profile.bio.isNotEmpty ? _profile.bio : 'Add a professional summary...', style: const TextStyle(fontSize: 13, color: AppColors.textGray), maxLines: 4, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _IconTextRow(icon: Icons.email_outlined, text: _profile.email.isNotEmpty ? _profile.email : 'Add Email'),
          const SizedBox(height: 8),
          _IconTextRow(icon: Icons.location_on_outlined, text: _profile.address.isNotEmpty ? _profile.address : 'Add Address'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ElevatedButton.icon(onPressed: () => _showSnackBar('Resume download started...'), icon: const Icon(Icons.download_rounded, size: 18), label: const Text('Download Your Resume', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12)))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: _showPrivacyDialog, icon: const Icon(Icons.privacy_tip_outlined, size: 18), label: Text('Privacy: ${_profile.privacyLevel}', style: const TextStyle(fontSize: 11)), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumeGenerator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        children: [
          const Row(children: [
            Icon(Icons.description_outlined, color: AppColors.primary),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Resume Generator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Generate professional resumes from your profile', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
            ]),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            _buildSmallButton(Icons.visibility_outlined, 'Preview Resume', Colors.blueGrey, onTap: () => _showSnackBar('Opening Resume Preview...')),
            const SizedBox(width: 8),
            _buildSmallButton(Icons.download_rounded, 'Download Resume', AppColors.primary, onTap: () => _showSnackBar('Resume generated & downloading...')),
            const SizedBox(width: 8),
            _buildSmallButton(Icons.tune_outlined, 'Advanced Options', Colors.white, textColor: AppColors.textDark, showBorder: true, onTap: () => _showSnackBar('Opening Advanced Resume Options...')),
          ]),
        ],
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, String label, Color color, {Color textColor = Colors.white, bool showBorder = false, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8), border: showBorder ? Border.all(color: AppColors.divider) : null),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _buildProfileCompleteness(double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(children: [
                Icon(Icons.check_circle_outline, color: Colors.teal),
                SizedBox(width: 8),
                Text('Profile Completeness', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
              Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text('${(progress * 100).toInt()}% complete — Improve for better resume and AI recommendations', style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: AppColors.divider, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)),
          ),
          const SizedBox(height: 24),
          const Text('Section Completion Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _buildChecklistItem('Basic Information', _profile.basicInfoProgress, Icons.person_outline, 
            missingMsg: _profile.basicInfoProgress < 1.0 ? "Fill all fields (Name, Bio, Email, Address)" : null),
          _buildChecklistItem('Education', _profile.educationProgress, Icons.school_outlined,
            missingMsg: _profile.educationProgress == 0 ? "Add at least one education entry" : null),
          _buildChecklistItem('Work Experience', _profile.experienceProgress, Icons.work_outline,
            missingMsg: _profile.experienceProgress == 0 ? "Add work experience" : null),
          _buildChecklistItem('Additional Information', _profile.projectsProgress, Icons.info_outline,
            missingMsg: _profile.projectsProgress == 0 ? "Add projects or additional info" : null),
          _buildChecklistItem('Profile Picture', _profile.pictureProgress, Icons.image_outlined, 
            isMissing: _profile.pictureProgress == 0, missingMsg: "Upload profile picture"),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String title, double progress, IconData icon, {bool isMissing = false, String? missingMsg}) {
    bool isComplete = progress == 1.0;
    Color color = isComplete ? Colors.teal : (isMissing || progress > 0 ? Colors.orange : Colors.grey);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Icon(isComplete ? Icons.check_circle : Icons.radio_button_unchecked, size: 14, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
              Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(color))),
          if (!isComplete && missingMsg != null) ...[
            const SizedBox(height: 8),
            const Text('Requirement:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
            Text('• $missingMsg', style: const TextStyle(fontSize: 11, color: Colors.red)),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileMilestones(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profile Milestones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(children: [
              const Icon(Icons.auto_awesome, size: 14, color: Colors.orange),
              const SizedBox(width: 4),
              Text('${((1.0 - progress) * 100).toInt()}% to Profile Master', style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
            ]),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMilestoneCard('Getting Started', '25%', Icons.emoji_events, progress >= 0.25),
              _buildMilestoneCard('Halfway There', '50%', Icons.emoji_events, progress >= 0.50),
              _buildMilestoneCard('Almost Complete', '75%', Icons.star, progress >= 0.75),
              _buildMilestoneCard('Profile Master', '100%', Icons.lock, progress >= 1.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneCard(String title, String percent, IconData icon, bool earned) {
    Color color = earned ? Colors.teal : Colors.grey;
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: earned ? Colors.teal.withOpacity(0.3) : AppColors.divider)),
      child: Column(
        children: [
          Icon(icon, color: earned ? Colors.orange : Colors.grey.shade300, size: 30),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: earned ? AppColors.textDark : Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: earned ? Colors.teal.withOpacity(0.1) : Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(earned ? Icons.check_circle : Icons.lock, size: 10, color: color),
              const SizedBox(width: 4),
              Text(earned ? 'Earned' : 'Locked', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholder(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Center(child: Text(message, style: const TextStyle(color: AppColors.textLight, fontSize: 13, fontStyle: FontStyle.italic))),
    );
  }

  Widget _buildPortfolioSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Column(
        children: [
          if (_profile.portfolioLinks.isEmpty)
            const Text('No portfolio links added yet', style: TextStyle(fontSize: 14, color: AppColors.textGray))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Portfolio Links', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._profile.portfolioLinks.asMap().entries.map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
                  child: Row(children: [
                    const Icon(Icons.link, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.value, style: const TextStyle(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis)),
                    IconButton(onPressed: () => setState(() => _profile.portfolioLinks.removeAt(e.key)), icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red)),
                  ]),
                )),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContentCard({required String title, required String subtitle, List<String>? details, String? description, required IconData icon, required VoidCallback onEdit, required VoidCallback onDelete}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                  Row(children: [
                    IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary)),
                    IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red)),
                  ]),
                ]),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textGray)),
                if (details != null) ...[
                  const SizedBox(height: 8),
                  ...details.map((d) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
                    Icon(d.contains(':') ? Icons.calendar_today_outlined : Icons.location_on_outlined, size: 14, color: AppColors.textLight),
                    const SizedBox(width: 6),
                    Text(d, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                  ]))),
                ],
                if (description != null) ...[
                  const SizedBox(height: 12),
                  Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textGray, height: 1.5)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  final String addLabel;
  const _SectionHeader({required this.title, required this.onAdd, this.addLabel = 'Add More'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: Text(addLabel, style: const TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), minimumSize: Size.zero),
          ),
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
