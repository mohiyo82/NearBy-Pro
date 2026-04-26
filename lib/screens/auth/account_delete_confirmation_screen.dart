import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class AccountDeleteConfirmationScreen extends StatefulWidget {
  const AccountDeleteConfirmationScreen({super.key});

  @override
  State<AccountDeleteConfirmationScreen> createState() => _AccountDeleteConfirmationScreenState();
}

class _AccountDeleteConfirmationScreenState extends State<AccountDeleteConfirmationScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleDelete() async {
    setState(() => _errorMessage = null);
    
    if (_passwordController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter your password to confirm');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Final Confirmation'),
        content: const Text('Are you sure? This will permanently delete your account and all professional data from our servers.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No, Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processDeletion();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Yes, Delete Everything'),
          ),
        ],
      ),
    );
  }

  Future<void> _processDeletion() async {
    setState(() => _isLoading = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.deleteAccount(_passwordController.text.trim());
      
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('wrong-password')) {
          _errorMessage = 'Incorrect password. Deletion failed.';
        } else {
          _errorMessage = 'Error: ${e.toString()}';
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 64),
            SizedBox(height: 24),
            Text('Account Deleted', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Your account and data have been removed permanently.', textAlign: TextAlign.center),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Delete Account', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_forever_rounded, size: 56, color: AppColors.error),
                ),
                const SizedBox(height: 20),
                const Text('Delete Your Account?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 10),
                const Text('This will permanently erase your profile, CV, and all saved data.', style: TextStyle(color: AppColors.textGray, fontSize: 14), textAlign: TextAlign.center),
              ]),
            ),
            const SizedBox(height: 40),
            const Text('Confirm with your password:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              onChanged: (_) => setState(() => _errorMessage = null),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleDelete,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Permanently Delete Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('I changed my mind, keep my account', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
