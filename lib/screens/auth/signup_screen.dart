import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();
  
  String? _selectedUserType;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  File? _profileImage;
  String? _errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dobController.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _signup() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(() => _errorMessage = 'Please agree to the Terms of Service');
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text,
        'userType': _selectedUserType,
        'profileImage': _profileImage?.path ?? '', 
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created! Please login.'), backgroundColor: Colors.green));
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMessage = 'This email is already registered. Please login.';
        } else if (e.code == 'weak-password') {
          _errorMessage = 'The password is too weak.';
        } else {
          _errorMessage = e.message ?? 'An error occurred during signup.';
        }
      });
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithGoogle();
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Google Sign-In failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create Account', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                      SizedBox(height: 4),
                      Text('Join NearBy Pro today', style: TextStyle(fontSize: 13, color: AppColors.textGray)),
                    ],
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null ? const Icon(Icons.person_add_alt_1_rounded, size: 28, color: AppColors.primary) : null,
                        ),
                        Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 12))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _label('Full Name'),
              const SizedBox(height: 8),
              TextFormField(controller: _nameController, decoration: const InputDecoration(hintText: 'Enter your full name', prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textGray)), validator: (val) => val == null || val.isEmpty ? 'Name is required' : null),
              const SizedBox(height: 20),
              
              _label('Email Address'),
              const SizedBox(height: 8),
              TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Enter your email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.textGray)), validator: (val) => val == null || val.isEmpty ? 'Email is required' : null),
              const SizedBox(height: 20),

              _label('Date of Birth'),
              const SizedBox(height: 8),
              TextFormField(controller: _dobController, readOnly: true, onTap: _selectDate, decoration: const InputDecoration(hintText: 'Select your birth date', prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.textGray)), validator: (val) => val == null || val.isEmpty ? 'Required' : null),
              const SizedBox(height: 20),
              
              _label('Phone Number'),
              const SizedBox(height: 8),
              TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '+92 --- -------', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textGray)), validator: (val) => val == null || val.isEmpty ? 'Phone is required' : null),
              const SizedBox(height: 20),
              
              _label('Password'),
              const SizedBox(height: 8),
              TextFormField(controller: _passwordController, obscureText: _obscurePassword, decoration: InputDecoration(hintText: 'Create a password', prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textGray), suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textGray), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))), validator: (val) => val == null || val.length < 6 ? 'Min 6 characters' : null),
              const SizedBox(height: 20),
              
              _label('Confirm Password'),
              const SizedBox(height: 8),
              TextFormField(controller: _confirmPasswordController, obscureText: _obscurePassword, decoration: const InputDecoration(hintText: 'Confirm your password', prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textGray)), validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null),
              const SizedBox(height: 20),
              
              _label('I am a'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(decoration: InputDecoration(filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)), prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textGray)), hint: const Text('Select user type'), value: _selectedUserType, items: const [DropdownMenuItem(value: 'student', child: Text('Student')), DropdownMenuItem(value: 'job_seeker', child: Text('Job Seeker')), DropdownMenuItem(value: 'business', child: Text('Business Explorer')), DropdownMenuItem(value: 'other', child: Text('Other'))], onChanged: (val) => setState(() => _selectedUserType = val), validator: (val) => val == null ? 'Required' : null),
              
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ),

              const SizedBox(height: 20),
              Row(children: [Checkbox(value: _agreedToTerms, onChanged: (val) => setState(() => _agreedToTerms = val ?? false), activeColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), const Expanded(child: Text.rich(TextSpan(text: 'I agree to the ', style: TextStyle(color: AppColors.textGray, fontSize: 13), children: [TextSpan(text: 'Terms of Service', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)), TextSpan(text: ' and '), TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))])))]),
              const SizedBox(height: 24),
              
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isLoading ? null : _signup, child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Create Account'))),
              const SizedBox(height: 24),
              
              Center(
                child: Column(
                  children: [
                    const Text('or sign up with', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _isLoading ? null : _handleGoogleSignIn,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                          ],
                        ),
                        child: _isLoading 
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                          : SvgPicture.network(
                              'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                              width: 24,
                              height: 24,
                            ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: AppColors.textGray, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('Login', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark));
}
