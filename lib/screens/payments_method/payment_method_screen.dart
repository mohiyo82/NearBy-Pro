import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = 'Credit Card';
  bool _isProcessing = false;

  // Controllers
  final _cardNameC = TextEditingController();
  final _cardNumberC = TextEditingController();
  final _expiryC = TextEditingController();
  final _cvvC = TextEditingController();
  final _mobileNumberC = TextEditingController();
  final _accountHolderC = TextEditingController();
  final _ibanC = TextEditingController();

  // Mock Saved Methods
  List<Map<String, dynamic>> _savedMethods = [
    {'type': 'Visa', 'label': 'Visa **** 4242', 'icon': Icons.credit_card},
    {'type': 'Easypaisa', 'label': '0300 **** 567', 'icon': Icons.account_balance_wallet_rounded},
  ];

  void _removeMethod(int index) {
    setState(() => _savedMethods.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment method removed'), backgroundColor: Colors.red));
  }

  void _processPayment() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text('Payment Successful!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Your Pro subscription is now active.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Done', onTap: () => Navigator.pop(context)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(title: const Text('Payment Methods')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_savedMethods.isNotEmpty) ...[
              const Text('Your Saved Methods', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ..._savedMethods.asMap().entries.map((e) => _buildSavedCard(e.key, e.value)),
              const SizedBox(height: 24),
            ],

            const Text('Add New Method', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildMethodOption('Credit Card', Icons.credit_card),
            _buildMethodOption('Easypaisa', Icons.account_balance_wallet_rounded),
            _buildMethodOption('JazzCash', Icons.wallet_membership_rounded),
            _buildMethodOption('Meezan Bank', Icons.account_balance_rounded),

            const SizedBox(height: 28),
            const Text('Payment Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDynamicFields(),

            const SizedBox(height: 40),
            PrimaryButton(
              label: _isProcessing ? 'Processing...' : 'Proceed to Checkout',
              isLoading: _isProcessing,
              onTap: _isProcessing ? null : _processPayment,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCard(int index, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: ListTile(
        leading: Icon(data['icon'], color: AppColors.primary),
        title: Text(data['label'], style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(data['type'], style: const TextStyle(fontSize: 12)),
        trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _removeMethod(index)),
      ),
    );
  }

  Widget _buildMethodOption(String title, IconData icon) {
    bool isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textGray, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.textDark)),
          const Spacer(),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
        ]),
      ),
    );
  }

  Widget _buildDynamicFields() {
    if (_selectedMethod == 'Credit Card') {
      return Column(children: [
        _tf(_cardNameC, 'Cardholder Name', Icons.person),
        _tf(_cardNumberC, 'Card Number', Icons.credit_card, kb: TextInputType.number),
        Row(children: [
          Expanded(child: _tf(_expiryC, 'MM/YY', Icons.calendar_today)),
          const SizedBox(width: 12),
          Expanded(child: _tf(_cvvC, 'CVV', Icons.lock_outline, kb: TextInputType.number)),
        ]),
      ]);
    } else if (_selectedMethod == 'Easypaisa' || _selectedMethod == 'JazzCash') {
      return Column(children: [
        _tf(_mobileNumberC, 'Mobile Number', Icons.phone_android, kb: TextInputType.phone),
        _tf(_accountHolderC, 'Account Holder Name', Icons.account_circle),
      ]);
    } else {
      return Column(children: [
        _tf(_ibanC, 'IBAN / Account Number', Icons.numbers),
        _tf(_accountHolderC, 'Title of Account', Icons.person),
      ]);
    }
  }

  Widget _tf(TextEditingController c, String h, IconData i, {TextInputType kb = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c, keyboardType: kb,
        decoration: InputDecoration(labelText: h, prefixIcon: Icon(i, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
