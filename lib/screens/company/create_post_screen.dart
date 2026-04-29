import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/database_service.dart';
import '../../services/cloudinary_service.dart';
import '../../theme/app_theme.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late RichTextController _contentC;
  File? _selectedImage;
  bool _isLoading = false;
  final _cloudinaryService = CloudinaryService();
  final _user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();

  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _contentC = RichTextController(
      onMatch: (List<String> matches) {},
      deleteOnBack: true,
    );
    _contentC.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    final text = _contentC.text.trim();
    if (text.isEmpty) {
      setState(() => _wordCount = 0);
    } else {
      setState(() => _wordCount = text.split(RegExp(r'\s+')).length);
    }
  }

  @override
  void dispose() {
    _contentC.removeListener(_updateWordCount);
    _contentC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _submitPost() async {
    if (_contentC.text.trim().isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add some content or an image')));
      return;
    }

    if (_wordCount > 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post cannot exceed 500 words')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _cloudinaryService.uploadImage(_selectedImage!);
        if (imageUrl == null) throw Exception("Image upload failed");
      }

      final dbService = Provider.of<DatabaseService>(context, listen: false);
      
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      
      final authorName = userData?['companyName'] ?? userData?['name'] ?? 'User';
      final authorLogo = userData?['photoUrl'] ?? userData?['profileImage'] ?? '';
      final authorType = userData?['activeMode'] ?? userData?['userType'] ?? 'user';

      await dbService.createPost({
        'content': _contentC.text.trim(),
        'imageUrl': imageUrl,
        'authorName': authorName,
        'authorLogo': authorLogo,
        'authorId': _user?.uid,
        'authorType': authorType,
        'type': 'user_post',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Post published!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Post', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextButton(
              onPressed: _isLoading ? null : _submitPost,
              child: Text(
                'Post', 
                style: TextStyle(
                  color: _isLoading ? Colors.grey : const Color(0xFF1B4332), 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(_user?.uid).get(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data() as Map<String, dynamic>?;
                      final name = data?['companyName'] ?? data?['name'] ?? 'Loading...';
                      final logo = data?['photoUrl'] ?? data?['profileImage'] ?? '';
                      
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
                            child: logo.isEmpty ? const Icon(Icons.person, color: Color(0xFF1B4332)) : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.public, size: 12, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('Anyone', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                                    Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Text Area (Open Space)
                  TextField(
                    controller: _contentC,
                    maxLines: null,
                    minLines: 8,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 18, height: 1.5, color: Colors.black87),
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                      border: InputBorder.none,
                      counterText: "", 
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '$_wordCount / 500 words',
                      style: TextStyle(
                        color: _wordCount > 500 ? Colors.red : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Image Preview
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10, right: 10,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 40),
                  // Prominent Upload Button at Bottom
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'UPLOAD POST', 
                            style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                              letterSpacing: 1.1
                            )
                          ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Toolbar
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10, left: 16, right: 16, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                _toolButton(Icons.image, Colors.blue, _pickImage),
                _toolButton(Icons.videocam, Colors.green, () {}),
                _toolButton(Icons.description, Colors.orange, () {}),
                _toolButton(Icons.more_horiz, Colors.grey, () {}),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    final text = _contentC.text;
                    _contentC.text = '$text #';
                    _contentC.selection = TextSelection.fromPosition(TextPosition(offset: _contentC.text.length));
                  },
                  child: const Text('Add hashtag', style: TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color),
    );
  }
}

class RichTextController extends TextEditingController {
  final Function(List<String>) onMatch;
  final bool deleteOnBack;

  RichTextController({required this.onMatch, this.deleteOnBack = false});

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<TextSpan> children = [];
    final pattern = RegExp(r"((?:#|@)[a-zA-Z0-9_]+)");

    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        children.add(TextSpan(
          text: match[0],
          style: style?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
        ));
        return "";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "";
      },
    );

    return TextSpan(style: style, children: children);
  }
}
