import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/cloudinary_service.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String companyId; 
  const CompanyProfileScreen({super.key, required this.companyId});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final DatabaseService _dbService = DatabaseService();
  bool _isFollowing = false;
  bool _isSaving = false;

  late TextEditingController _nameC;
  late TextEditingController _taglineC;
  late TextEditingController _industryC;
  late TextEditingController _locationC;
  late TextEditingController _employeeCountC;
  late TextEditingController _websiteC;
  late TextEditingController _descriptionC;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _nameC = TextEditingController();
    _taglineC = TextEditingController();
    _industryC = TextEditingController();
    _locationC = TextEditingController();
    _employeeCountC = TextEditingController();
    _websiteC = TextEditingController();
    _descriptionC = TextEditingController();
    _checkFollowStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameC.dispose();
    _taglineC.dispose();
    _industryC.dispose();
    _locationC.dispose();
    _employeeCountC.dispose();
    _websiteC.dispose();
    _descriptionC.dispose();
    super.dispose();
  }

  Future<void> _checkFollowStatus() async {
    if (_currentUser == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('following')
        .doc(widget.companyId)
        .get();
    if (mounted) setState(() => _isFollowing = doc.exists);
  }

  Future<void> _toggleFollow() async {
    if (_currentUser == null) return;
    await _dbService.toggleFollow(widget.companyId, _isFollowing);
    if (mounted) setState(() => _isFollowing = !_isFollowing);
  }

  Future<void> _pickAndUploadImage(bool isBanner) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    if (image != null) {
      setState(() => _isSaving = true);
      try {
        final url = await _cloudinaryService.uploadImage(File(image.path));
        if (url != null) {
          await FirebaseFirestore.instance.collection('users').doc(widget.companyId).update({
            isBanner ? 'bannerUrl' : 'photoUrl': url,
          });
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${isBanner ? 'Banner' : 'Logo'} updated!')));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final updates = {
        'companyName': _nameC.text.trim(),
        'name': _nameC.text.trim(),
        'tagline': _taglineC.text.trim(),
        'industry': _industryC.text.trim(),
        'location': _locationC.text.trim(),
        'employeeCount': _employeeCountC.text.trim(),
        'website': _websiteC.text.trim(),
        'description': _descriptionC.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('users').doc(widget.companyId).update(updates);
      final regDocs = await FirebaseFirestore.instance.collection('company_registrations').where('userId', isEqualTo: widget.companyId).get();
      if (regDocs.docs.isNotEmpty) {
        await regDocs.docs.first.reference.update(updates);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showEditOptions(Map<String, dynamic> currentData) {
    _nameC.text = currentData['companyName'] ?? currentData['name'] ?? '';
    _taglineC.text = currentData['tagline'] ?? '';
    _industryC.text = currentData['industry'] ?? '';
    _locationC.text = currentData['location'] ?? '';
    _employeeCountC.text = currentData['employeeCount'] ?? '';
    _websiteC.text = currentData['website'] ?? '';
    _descriptionC.text = currentData['description'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Text('Edit Company Page', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(height: 24),
                _buildEditField('Company Name', _nameC),
                _buildEditField('Tagline', _taglineC),
                _buildEditField('Industry', _industryC),
                _buildEditField('Location', _locationC),
                _buildEditField('Employee Count', _employeeCountC),
                _buildEditField('Website', _websiteC),
                _buildEditField('Description', _descriptionC, maxLines: 4),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildUploadButton(Icons.image, 'Edit Banner', () => _pickAndUploadImage(true))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildUploadButton(Icons.add_a_photo, 'Edit Logo', () => _pickAndUploadImage(false))),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : () async {
                      setModalState(() => _isSaving = true);
                      await _saveChanges();
                      setModalState(() => _isSaving = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4332),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: _isSaving 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SAVE ALL CHANGES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.blueAccent, size: 20),
      label: Text(label, style: const TextStyle(color: Colors.white70)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white12),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent)),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = _currentUser?.uid == widget.companyId;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_currentUser?.uid).snapshots(),
      builder: (context, authUserSnapshot) {
        final authData = authUserSnapshot.data?.data() as Map<String, dynamic>? ?? {};
        final String activeMode = authData['activeMode'] ?? 'user';
        bool canEdit = isOwner && activeMode == 'company';

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.companyId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Scaffold(backgroundColor: Color(0xFF121212), body: Center(child: CircularProgressIndicator(color: Color(0xFF1B4332))));
            
            final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('company_registrations')
                  .where('userId', isEqualTo: widget.companyId)
                  .limit(1)
                  .snapshots(),
              builder: (context, regSnapshot) {
                Map<String, dynamic> data = Map.from(userData);
                if (regSnapshot.hasData && regSnapshot.data!.docs.isNotEmpty) {
                  data.addAll(regSnapshot.data!.docs.first.data() as Map<String, dynamic>);
                }

                final name = data['companyName'] ?? data['name'] ?? 'Company Name';
                final tagline = data['tagline'] ?? 'Innovation meets Vision.';
                final industry = data['industry'] ?? 'IT Services & Consulting';
                final location = data['location'] ?? 'Lahore, Pakistan';
                final employees = data['employeeCount'] ?? '10-50 employees';
                final bannerUrl = data['bannerUrl'];
                final logoUrl = data['photoUrl'] ?? data['profileImage'];
                final followersCount = data['followersCount'] ?? 0;

                return Scaffold(
                  backgroundColor: const Color(0xFF121212),
                  body: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        expandedHeight: 380,
                        pinned: true,
                        backgroundColor: const Color(0xFF121212),
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        actions: [
                          if (canEdit)
                            IconButton(
                              icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
                              onPressed: () => _showEditOptions(data),
                            ),
                          if (!isOwner)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: ElevatedButton(
                                onPressed: _toggleFollow,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isFollowing ? Colors.white12 : Colors.blueAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  _isFollowing ? 'Following' : 'Follow', 
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Stack(
                            children: [
                              GestureDetector(
                                onTap: canEdit ? () => _pickAndUploadImage(true) : null,
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: (bannerUrl != null && bannerUrl.isNotEmpty) 
                                    ? Image.network(bannerUrl, fit: BoxFit.cover)
                                    : const Center(child: Opacity(opacity: 0.2, child: Icon(Icons.business_rounded, color: Colors.white, size: 80))),
                                ),
                              ),
                              Positioned(
                                top: 140,
                                left: 20,
                                child: GestureDetector(
                                  onTap: canEdit ? () => _pickAndUploadImage(false) : null,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF121212),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: (logoUrl != null && logoUrl.isNotEmpty) 
                                        ? Image.network(logoUrl, width: 90, height: 90, fit: BoxFit.cover)
                                        : Container(
                                            width: 90, height: 90, 
                                            color: const Color(0xFF1B4332),
                                            child: const Icon(Icons.business_rounded, color: Colors.white, size: 45),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 245,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Text(tagline, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.3)),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(Icons.business_center_outlined, size: 14, color: Colors.white54),
                                          const SizedBox(width: 4),
                                          Text('$industry', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.white54),
                                          const SizedBox(width: 4),
                                          Text('$location', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text('$employees • $followersCount followers', style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: Colors.blueAccent,
                            unselectedLabelColor: Colors.white54,
                            indicatorColor: Colors.blueAccent,
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                            tabs: const [
                              Tab(text: 'Home'),
                              Tab(text: 'About'),
                              Tab(text: 'Posts'),
                              Tab(text: 'Jobs'),
                            ],
                          ),
                        ),
                      ),
                    ],
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildHomeTab(data, canEdit),
                        _buildAboutTab(data),
                        _buildPostsTab(canEdit),
                        _buildJobsTab(),
                      ],
                    ),
                  ),
                );
              }
            );
          },
        );
      },
    );
  }

  Widget _buildHomeTab(Map<String, dynamic> data, bool canEdit) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Text(
          data['description'] ?? 'No description provided by the company.', 
          style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 14),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _tabController.animateTo(1), 
          child: const Text('Read More', style: TextStyle(color: Colors.blueAccent))
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton(onPressed: () => _tabController.animateTo(2), child: const Text('View All', style: TextStyle(color: Colors.blueAccent))),
          ],
        ),
        const SizedBox(height: 8),
        _buildPostsListPreview(canEdit),
      ],
    );
  }

  Widget _buildPostsListPreview(bool canEdit) {
    return StreamBuilder<QuerySnapshot>(
      // Manual sorting to bypass Firestore index requirement
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: widget.companyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading activity.', style: TextStyle(color: Colors.white38, fontSize: 11)));
        }
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        
        final posts = snapshot.data!.docs.toList();
        posts.sort((a, b) {
          final t1 = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
          final t2 = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
          return t2.compareTo(t1);
        });

        if (posts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No recent updates yet.', style: TextStyle(color: Colors.white38)),
            ),
          );
        }

        final recentPosts = posts.take(3).toList();
        return Column(
          children: recentPosts.map((doc) => _postCard(doc.id, doc.data() as Map<String, dynamic>, canEdit)).toList(),
        );
      },
    );
  }

  Widget _buildAboutTab(Map<String, dynamic> data) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Company Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Text(
          data['description'] ?? 'No detailed description provided.', 
          style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 14)
        ),
        const SizedBox(height: 32),
        _aboutRow(Icons.language, 'Website', data['website'] ?? 'N/A'),
        _aboutRow(Icons.business_center, 'Industry', data['industry'] ?? 'N/A'),
        _aboutRow(Icons.people, 'Company size', data['employeeCount'] ?? 'N/A'),
        _aboutRow(Icons.location_on, 'Headquarters', data['location'] ?? 'N/A'),
      ],
    );
  }

  Widget _aboutRow(IconData icon, String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.blueAccent.withValues(alpha: 0.6)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
              const SizedBox(height: 2),
              Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab(bool canEdit) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: widget.companyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Posts not loading.', style: TextStyle(color: Colors.white38)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        
        final posts = snapshot.data!.docs.toList();
        posts.sort((a, b) {
          final t1 = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
          final t2 = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp? ?? Timestamp.now();
          return t2.compareTo(t1);
        });

        if (posts.isEmpty) return const Center(child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('No posts published yet.', style: TextStyle(color: Colors.white54)),
        ));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final doc = posts[index];
            return _postCard(doc.id, doc.data() as Map<String, dynamic>, canEdit);
          },
        );
      },
    );
  }

  Widget _postCard(String postId, Map<String, dynamic> post, bool canEdit) {
    final List<dynamic> likedBy = post['likedBy'] ?? [];
    final bool isLiked = likedBy.contains(_currentUser?.uid);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF1B4332),
                backgroundImage: (post['authorLogo'] != null && post['authorLogo'].isNotEmpty) ? NetworkImage(post['authorLogo']) : null,
                child: (post['authorLogo'] == null || post['authorLogo'].isEmpty) ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(post['authorName'] ?? 'User', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)), 
                    Text(
                      post['timestamp'] != null ? DateFormat('MMM d, yyyy').format((post['timestamp'] as Timestamp).toDate()) : 'Recent',
                      style: const TextStyle(fontSize: 11, color: Colors.white38)
                    )
                  ]
                )
              ),
              if (canEdit)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: Colors.white54),
                  color: const Color(0xFF2A2A2A),
                  onSelected: (val) {
                    if (val == 'edit') _showEditPostDialog(postId, post['content']);
                    if (val == 'delete') _showDeletePostDialog(postId);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit Post', style: TextStyle(color: Colors.white))),
                    const PopupMenuItem(value: 'delete', child: Text('Delete Post', style: TextStyle(color: Colors.red))),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(post['content'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14.5, height: 1.4)),
          if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post['imageUrl'],
                height: 220, width: double.infinity, 
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.white24),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _postAction(
                isLiked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                '${post['likes'] ?? 0}',
                isLiked ? Colors.blueAccent : Colors.white54,
                () => _dbService.toggleLike(postId, isLiked),
              ),
              _postAction(
                Icons.comment_outlined,
                '${post['comments'] ?? 0}',
                Colors.white54,
                () => _showCommentsBottomSheet(postId),
              ),
              _postAction(Icons.share_outlined, 'Share', Colors.white54, () {}),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditPostDialog(String postId, String oldContent) {
    final editC = TextEditingController(text: oldContent);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Edit Post', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: editC,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter content..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _dbService.updatePost(postId, editC.text);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeletePostDialog(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Post', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this post?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _dbService.deletePost(postId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(String postId) {
    final commentC = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Comments', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final comments = snapshot.data!.docs;
                    if (comments.isEmpty) return const Center(child: Text('No comments yet.', style: TextStyle(color: Colors.white38)));

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index].data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundImage: (comment['userPhoto'] != null && comment['userPhoto'].isNotEmpty) ? NetworkImage(comment['userPhoto']) : null,
                            child: (comment['userPhoto'] == null || comment['userPhoto'].isEmpty) ? const Icon(Icons.person, size: 16) : null,
                          ),
                          title: Text(comment['userName'] ?? 'User', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(comment['text'] ?? '', style: const TextStyle(color: Colors.white70)),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentC,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      if (commentC.text.trim().isNotEmpty) {
                        await _dbService.addComment(postId, commentC.text);
                        commentC.clear();
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postAction(IconData icon, String label, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500))
      ]
    ),
  );

  Widget _buildJobsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('companyId', isEqualTo: widget.companyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        
        final jobs = snapshot.data!.docs.toList();
        jobs.sort((a, b) {
          final t1 = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp? ?? Timestamp.now();
          final t2 = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp? ?? Timestamp.now();
          return t2.compareTo(t1);
        });

        if (jobs.isEmpty) return const Center(child: Text('No job openings available.', style: TextStyle(color: Colors.white54)));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index].data() as Map<String, dynamic>;
            return Card(
              color: const Color(0xFF1E1E1E),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(job['title'] ?? 'Job Title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('${job['jobType']} • ${job['workMode']}', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blueAccent),
                onTap: () => Navigator.pushNamed(context, '/result-detail', arguments: job),
              ),
            );
          },
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: const Color(0xFF121212), child: _tabBar);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
