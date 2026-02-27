import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AccountDeleteConfirmationScreen extends StatefulWidget {
  const AccountDeleteConfirmationScreen({super.key});

  @override
  State<AccountDeleteConfirmationScreen> createState() => _AccountDeleteConfirmationScreenState();
}

class _AccountDeleteConfirmationScreenState extends State<AccountDeleteConfirmationScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleDelete() {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password to confirm'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Final Confirmation'),
        content: const Text('Are you sure you want to schedule your account for deletion? You will have 30 days to cancel this request.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No, Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processDeletion();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }

  void _processDeletion() {
    setState(() => _isLoading = true);
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.timer_outlined, color: AppColors.error, size: 48),
            ),
            const SizedBox(height: 24),
            const Text('Account Scheduled', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Your account will be permanently deleted in 30 days. You can log back in anytime before then to cancel this request.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGray, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text('OK'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
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
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_forever_rounded, size: 56, color: AppColors.error),
                ),
                const SizedBox(height: 20),
                const Text('Delete Your Account?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 10),
                const Text('This action is permanent and cannot be undone after 30 days.', style: TextStyle(color: AppColors.textGray, fontSize: 14), textAlign: TextAlign.center),
              ]),
            ),
            const SizedBox(height: 28),
            const Text('What will be deleted:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            ...[
              'Your profile and resume data',
              'All saved places and contacts',
              'Search history and preferences',
              'All applications sent',
            ].map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    const Icon(Icons.remove_circle_rounded, color: AppColors.error, size: 18),
                    const SizedBox(width: 10),
                    Text(item, style: const TextStyle(color: AppColors.textGray, fontSize: 14)),
                  ]),
                )),
            const SizedBox(height: 20),
            const Text('Confirm with your password:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Keep My Account', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
