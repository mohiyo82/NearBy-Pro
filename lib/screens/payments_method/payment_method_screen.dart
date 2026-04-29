import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = 'easypaisa';
  bool _isProcessing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _mobileC = TextEditingController();
  final _nameC = TextEditingController();
  final _cardNumberC = TextEditingController();
  final _expiryC = TextEditingController();
  final _cvvC = TextEditingController();
  final _ibanC = TextEditingController();

  // Using reliable public URLs for original logos
  final List<Map<String, String>> _methods = [
    {
      'id': 'easypaisa', 
      'title': 'Easypaisa', 
      'icon': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz-93lK-T-yU_m8V6Yn3D_Aatp4U0V9O-vjA&s'
    },
    {
      'id': 'jazzcash', 
      'title': 'JazzCash', 
      'icon': 'https://seeklogo.com/images/J/jazz-cash-logo-829841352F-seeklogo.com.png'
    },
    {
      'id': 'meezan', 
      'title': 'Meezan Bank', 
      'icon': 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Meezan_Bank_Logo.svg/1200px-Meezan_Bank_Logo.svg.png'
    },
    {
      'id': 'card', 
      'title': 'Credit/Debit Card', 
      'icon': 'https://cdn-icons-png.flaticon.com/512/349/349221.png'
    },
  ];

  @override
  void dispose() {
    _mobileC.dispose();
    _nameC.dispose();
    _cardNumberC.dispose();
    _expiryC.dispose();
    _cvvC.dispose();
    _ibanC.dispose();
    super.dispose();
  }

  void _handlePayment() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isProcessing = false);
          _showSuccessDialog();
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('Payment Successful', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your payment method has been verified.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              
              ..._methods.map((method) => _buildMethodTile(method)).toList(),
              
              const SizedBox(height: 32),
              const Text('Enter Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              
              _buildDynamicFields(),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4332),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isProcessing 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text('Verify & Save', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTile(Map<String, String> method) {
    bool isSelected = _selectedMethod == method['id'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method['id']!;
          _formKey.currentState?.reset();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF1B4332) : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  method['icon']!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(_getFallbackIcon(method['id']!), color: const Color(0xFF1B4332)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(method['title']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const Spacer(),
            Radio<String>(
              value: method['id']!,
              groupValue: _selectedMethod,
              activeColor: const Color(0xFF1B4332),
              onChanged: (val) => setState(() => _selectedMethod = val!),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFallbackIcon(String id) {
    switch (id) {
      case 'easypaisa': return Icons.account_balance_wallet_rounded;
      case 'jazzcash': return Icons.wallet_rounded;
      case 'meezan': return Icons.account_balance_rounded;
      default: return Icons.credit_card_rounded;
    }
  }

  Widget _buildDynamicFields() {
    if (_selectedMethod == 'easypaisa' || _selectedMethod == 'jazzcash') {
      return Column(
        children: [
          _buildTextField(_nameC, 'Account Holder Name', Icons.person_outline, validator: (v) => v!.isEmpty ? 'Enter name' : null),
          const SizedBox(height: 16),
          _buildTextField(_mobileC, 'Mobile Number', Icons.phone_android_rounded, 
            kb: TextInputType.phone, 
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
            validator: (v) => (v!.length < 11) ? 'Enter valid 11 digit number' : null),
        ],
      );
    } else if (_selectedMethod == 'meezan') {
      return Column(
        children: [
          _buildTextField(_nameC, 'Account Title', Icons.person_outline, validator: (v) => v!.isEmpty ? 'Enter account title' : null),
          const SizedBox(height: 16),
          _buildTextField(_ibanC, 'IBAN / Account Number', Icons.account_balance_rounded, 
            validator: (v) => v!.length < 10 ? 'Enter valid account number' : null),
        ],
      );
    } else {
      return Column(
        children: [
          _buildTextField(_cardNumberC, 'Card Number', Icons.credit_card_rounded, 
            kb: TextInputType.number, 
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
            validator: (v) => v!.length < 16 ? 'Enter 16 digit card number' : null),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(_expiryC, 'Expiry (MM/YY)', Icons.calendar_today_rounded, 
                kb: TextInputType.number, 
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
                validator: (v) => !v!.contains('/') ? 'Use MM/YY' : null)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField(_cvvC, 'CVV', Icons.lock_outline_rounded, 
                kb: TextInputType.number, 
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                validator: (v) => v!.length < 3 ? 'Invalid CVV' : null)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(_nameC, 'Name on Card', Icons.person_outline, validator: (v) => v!.isEmpty ? 'Enter name' : null),
        ],
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType kb = TextInputType.text, List<TextInputFormatter>? inputFormatters, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: kb,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1B4332)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B4332), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
