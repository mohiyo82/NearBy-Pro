import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final User? _user = FirebaseAuth.instance.currentUser;

  // Controllers
  final _mobileC = TextEditingController();
  final _nameC = TextEditingController();
  final _cardNumberC = TextEditingController();
  final _expiryC = TextEditingController();
  final _cvvC = TextEditingController();
  final _ibanC = TextEditingController();

  final List<Map<String, String>> _methods = [
    {
      'id': 'easypaisa', 
      'title': 'Easypaisa', 
      'icon': 'assets/images/easypaisa_logo.png'
    },
    {
      'id': 'jazzcash', 
      'title': 'JazzCash', 
      'icon': 'assets/images/jazz_logo.png'
    },
    {
      'id': 'meezan', 
      'title': 'Meezan Bank', 
      'icon': 'assets/images/meezan_logo.png'
    },
    {
      'id': 'card', 
      'title': 'Credit/Debit Card', 
      'icon': 'assets/images/credit_logo.jpg'
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

  Future<void> _handlePayment() async {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String planId = args?['plan'] ?? 'monthly_pro';

    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      try {
        DateTime now = DateTime.now();
        DateTime expiryDate = planId == 'yearly_pro' ? now.add(const Duration(days: 365)) : now.add(const Duration(days: 30));

        if (_user != null) {
          // Update Firestore for Pro Status
          await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update({
            'isPro': true,
            'activePlan': planId,
            'proActivatedAt': FieldValue.serverTimestamp(),
            'proExpiresAt': Timestamp.fromDate(expiryDate),
          });
        }

        if (mounted) {
          setState(() => _isProcessing = false);
          _showSuccessDialog();
        }
      } catch (e) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Error: $e')));
      }
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
                  Navigator.pop(ctx); // Close Success Dialog
                  _showProCongratsPopup(); // Show the Image Popup
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProCongratsPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/pro_member_popup.jpeg', 
                      fit: BoxFit.cover, 
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300, 
                        color: Colors.grey[200], 
                        child: const Icon(Icons.stars_rounded, size: 100, color: Colors.amber)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(ctx); // Close Popup
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false); // Go to Home
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF1B4332), shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                ),
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
                child: Image.asset(
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
          _buildTextField(_nameC, 'Account Holder Name', Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(_mobileC, 'Mobile Number', Icons.phone_android_rounded, kb: TextInputType.phone),
        ],
      );
    } else if (_selectedMethod == 'meezan') {
      return Column(
        children: [
          _buildTextField(_nameC, 'Account Title', Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(_ibanC, 'IBAN / Account Number', Icons.account_balance_rounded),
        ],
      );
    } else {
      return Column(
        children: [
          _buildTextField(_cardNumberC, 'Card Number', Icons.credit_card_rounded, kb: TextInputType.number),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(_expiryC, 'Expiry (MM/YY)', Icons.calendar_today_rounded, kb: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField(_cvvC, 'CVV', Icons.lock_outline_rounded, kb: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(_nameC, 'Name on Card', Icons.person_outline),
        ],
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType kb = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: kb,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1B4332)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B4332), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}
