import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
    {'id': 'easypaisa', 'title': 'Easypaisa', 'icon': 'assets/images/easypaisa_logo.png'},
    {'id': 'jazzcash', 'title': 'JazzCash', 'icon': 'assets/images/jazz_logo.png'},
    {'id': 'meezan', 'title': 'Meezan Bank', 'icon': 'assets/images/meezan_logo.png'},
    {'id': 'card', 'title': 'Credit/Debit Card', 'icon': 'assets/images/credit_logo.jpg'},
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

  void _showSystemNotification(String title, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 8,
        right: 8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF1B4332), shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_active, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text(message, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 4), () => overlayEntry.remove());
  }

  Future<void> _handlePayment() async {
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String planId = args?['plan'] ?? 'monthly_pro';
    final String planTitle = args?['title'] ?? 'Pro Plan';
    final String planPrice = args?['price'] ?? '\$10';

    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      try {
        DateTime now = DateTime.now();
        DateTime expiryDate = planId == 'yearly_pro' ? now.add(const Duration(days: 365)) : now.add(const Duration(days: 30));

        Map<String, dynamic> paymentData = {
          'method': _selectedMethod,
          'planId': planId,
          'planTitle': planTitle,
          'price': planPrice,
          'timestamp': FieldValue.serverTimestamp(),
          'expiresAt': Timestamp.fromDate(expiryDate),
          'status': 'active',
        };

        if (_selectedMethod == 'card') {
          paymentData['details'] = 'Card ending in ${_cardNumberC.text.substring(_cardNumberC.text.length - 4)}';
        } else if (_selectedMethod == 'meezan') {
          paymentData['details'] = 'IBAN: ${_ibanC.text.substring(0, 4)}...';
        } else {
          paymentData['details'] = 'Mobile: ${_mobileC.text.replaceRange(3, 7, '****')}';
        }

        if (_user != null) {
          await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update({
            'isPro': true,
            'activePlan': planId,
            'proActivatedAt': FieldValue.serverTimestamp(),
            'proExpiresAt': Timestamp.fromDate(expiryDate),
          });

          await FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('payments').add(paymentData);
        }

        if (mounted) {
          setState(() => _isProcessing = false);
          _showSystemNotification('NearBy Pro', 'Your $planTitle has been activated successfully!');
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
                  Navigator.pop(ctx);
                  _showProCongratsPopup();
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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/pro_member_popup.jpeg', fit: BoxFit.cover, width: double.infinity),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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

  Future<void> _deletePaymentMethod(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_user?.uid).collection('payments').doc(docId).delete();
      final remaining = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).collection('payments').get();
      if (remaining.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(_user?.uid).update({'isPro': false, 'activePlan': 'free', 'proExpiresAt': null});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Payment Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Subscriptions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildActiveSubscriptionList(),
                  const SizedBox(height: 32),
                  const Text('Add New Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ..._methods.map((method) => _buildMethodTile(method)).toList(),
                  const SizedBox(height: 24),
                  const Text('Payment Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Form(key: _formKey, child: _buildDynamicFields()),
                  const SizedBox(height: 32),
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
                        : const Text('Process Payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSubscriptionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user?.uid).collection('payments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('No active payment methods found.', style: TextStyle(color: Colors.grey))),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final Timestamp? expiresAt = data['expiresAt'];
            int daysLeft = expiresAt != null ? expiresAt.toDate().difference(DateTime.now()).inDays : 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFF1B4332), child: Icon(Icons.credit_score, color: Colors.white)),
                title: Text(data['planTitle'] ?? 'Pro Plan', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data['method'].toUpperCase()} • ${data['details']}'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: daysLeft > 5 ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text('$daysLeft days remaining', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: daysLeft > 5 ? Colors.green : Colors.red)),
                    ),
                  ],
                ),
                trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deletePaymentMethod(doc.id)),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMethodTile(Map<String, String> method) {
    bool isSelected = _selectedMethod == method['id'];
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method['id']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF1B4332) : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Image.asset(method['icon']!, width: 40, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.payment)),
            const SizedBox(width: 16),
            Text(method['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1B4332)),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFields() {
    if (_selectedMethod == 'easypaisa' || _selectedMethod == 'jazzcash') {
      return Column(children: [_buildTextField(_nameC, 'Account Holder Name', Icons.person_outline), const SizedBox(height: 16), _buildTextField(_mobileC, 'Mobile Number', Icons.phone_android_rounded, kb: TextInputType.phone)]);
    } else if (_selectedMethod == 'meezan') {
      return Column(children: [_buildTextField(_nameC, 'Account Title', Icons.person_outline), const SizedBox(height: 16), _buildTextField(_ibanC, 'IBAN / Account Number', Icons.account_balance_rounded)]);
    } else {
      return Column(children: [_buildTextField(_cardNumberC, 'Card Number', Icons.credit_card_rounded, kb: TextInputType.number), const SizedBox(height: 16), Row(children: [Expanded(child: _buildTextField(_expiryC, 'MM/YY', Icons.calendar_today_rounded)), const SizedBox(width: 16), Expanded(child: _buildTextField(_cvvC, 'CVV', Icons.lock_outline_rounded, kb: TextInputType.number))])]);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType kb = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: kb,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFF1B4332)), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}
