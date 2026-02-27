import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = 'Credit Card';
  
  // Controllers for all fields
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _walletEmailController = TextEditingController();
  final _bankAccountController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _walletEmailController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final plan = args?['plan'] ?? 'Pro Plan';
    final price = args?['price'] ?? '\$10';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Payment Method')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Plan', style: TextStyle(color: AppColors.textGray)),
                      Text(plan, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount', style: TextStyle(color: AppColors.textGray)),
                      Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            _buildMethodItem(Icons.credit_card_rounded, 'Credit Card', 'Visa, Mastercard, etc.'),
            _buildMethodItem(Icons.account_balance_wallet_rounded, 'Digital Wallet', 'PayPal, Google Pay'),
            _buildMethodItem(Icons.account_balance_rounded, 'Bank Transfer', 'Direct from your bank'),
            const SizedBox(height: 32),
            
            // ─── Dynamic Input Fields ───
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),

            if (_selectedMethod == 'Credit Card') ...[
              _buildInput('Cardholder Name', 'John Doe', _cardNameController),
              const SizedBox(height: 16),
              _buildInput('Card Number', '0000 0000 0000 0000', _cardNumberController, icon: Icons.credit_card),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInput('Expiry Date', 'MM/YY', _expiryController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInput('CVV', '***', _cvvController)),
                ],
              ),
            ] else if (_selectedMethod == 'Digital Wallet') ...[
              _buildInput('Wallet Email / ID', 'example@paypal.com', _walletEmailController, icon: Icons.alternate_email_rounded),
            ] else if (_selectedMethod == 'Bank Transfer') ...[
              _buildInput('Account Number / IBAN', 'PK00 UNIL 0000 0000...', _bankAccountController, icon: Icons.account_balance_rounded),
            ],

            const SizedBox(height: 40),

            PrimaryButton(
              label: 'Pay Now $price',
              onTap: () {
                // Validation
                if (_selectedMethod == 'Credit Card' && (_cardNameController.text.isEmpty || _cardNumberController.text.isEmpty)) {
                  _showSnackBar('Please enter card details');
                  return;
                }
                
                _showSnackBar('Connecting to Secure Gateway...');
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    _showSnackBar('Payment Successful! Welcome to Pro.');
                    Navigator.popUntil(context, ModalRoute.withName('/settings'));
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 14, color: AppColors.textLight),
                  SizedBox(width: 4),
                  Text('Secure SSL Encrypted Payment', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: AppColors.primary, size: 20) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodItem(IconData icon, String title, String subtitle) {
    final isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGray)),
                ],
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: _selectedMethod,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _selectedMethod = v!),
            ),
          ],
        ),
      ),
    );
  }
}
