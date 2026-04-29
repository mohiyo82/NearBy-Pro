import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  int _getTier(String? planId) {
    if (planId == 'yearly_pro') return 2;
    if (planId == 'monthly_pro') return 1;
    return 0; // free
  }

  Future<void> _cancelSubscription(BuildContext context, String uid) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Subscription?'),
        content: const Text('You will lose all premium benefits immediately.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep it')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'isPro': false,
          'activePlan': 'free',
          'proExpiresAt': null,
          'proActivatedAt': null,
        });
        
        // Mark the payment as cancelled in history
        final payments = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('payments')
            .where('status', isEqualTo: 'active')
            .get();
            
        for (var doc in payments.docs) {
          await doc.reference.update({'status': 'cancelled'});
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription cancelled.')));
        }
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Subscription Plans', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, userSnapshot) {
          String currentPlanId = 'free';
          Timestamp? expiresAt;
          bool isUserPro = false;
          
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            final data = userSnapshot.data!.data() as Map<String, dynamic>;
            expiresAt = data['proExpiresAt'];
            bool hasExpired = expiresAt != null && expiresAt.toDate().isBefore(DateTime.now());
            isUserPro = (data['isPro'] ?? false) && !hasExpired;
            currentPlanId = isUserPro ? (data['activePlan'] ?? 'free') : 'free';
          }

          int currentTier = _getTier(currentPlanId);

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .collection('payments')
                .where('status', isEqualTo: 'active')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, paymentSnapshot) {
              Map<String, dynamic>? paymentDetails;
              if (paymentSnapshot.hasData && paymentSnapshot.data!.docs.isNotEmpty) {
                paymentDetails = paymentSnapshot.data!.docs.first.data() as Map<String, dynamic>;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Choose Your Plan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    const SizedBox(height: 8),
                    const Text('Unlock premium features and get the most out of NearBy Pro.', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                    const SizedBox(height: 32),
                    
                    _buildPlanCard(
                      context,
                      title: 'Free',
                      id: 'free',
                      price: '\u00240',
                      period: '/ month',
                      features: ['Basic search access', 'Up to 5 saved places', 'Standard support'],
                      color: Colors.grey,
                      currentPlanId: currentPlanId,
                      uid: user?.uid,
                      planTier: 0,
                      currentTier: currentTier,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildPlanCard(
                      context,
                      title: 'Monthly Pro',
                      id: 'monthly_pro',
                      price: '\u002410',
                      period: '/ month',
                      features: ['Unlimited search access', 'Priority support', 'AI recommendations'],
                      color: const Color(0xFF1B4332),
                      isRecommended: true,
                      currentPlanId: currentPlanId,
                      uid: user?.uid,
                      expiryDate: currentPlanId == 'monthly_pro' ? expiresAt : null,
                      planTier: 1,
                      currentTier: currentTier,
                      paymentInfo: currentPlanId == 'monthly_pro' ? paymentDetails : null,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildPlanCard(
                      context,
                      title: 'Yearly Pro',
                      id: 'yearly_pro',
                      price: '\u002480',
                      period: '/ year',
                      subtitle: 'Save 33%',
                      features: ['All Monthly features', 'Offline maps', 'Exclusive webinars'],
                      color: const Color(0xFF2D6A4F),
                      currentPlanId: currentPlanId,
                      uid: user?.uid,
                      expiryDate: currentPlanId == 'yearly_pro' ? expiresAt : null,
                      planTier: 2,
                      currentTier: currentTier,
                      paymentInfo: currentPlanId == 'yearly_pro' ? paymentDetails : null,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String id,
    required String price,
    required String period,
    String? subtitle,
    required List<String> features,
    required Color color,
    required String currentPlanId,
    required int planTier,
    required int currentTier,
    Timestamp? expiryDate,
    String? uid,
    bool isRecommended = false,
    Map<String, dynamic>? paymentInfo,
  }) {
    bool isThisPlanActive = (currentPlanId == id);
    String buttonText = 'Select Plan';
    VoidCallback? onMainPressed;
    Color buttonColor = color;

    if (isThisPlanActive) {
      buttonText = 'Plan Active';
      onMainPressed = null;
      buttonColor = Colors.grey.shade400;
    } else {
      if (planTier > currentTier) {
        buttonText = 'Upgrade Now';
      } else if (planTier < currentTier && id != 'free') {
        buttonText = 'Switch Plan';
      }
      onMainPressed = () => Navigator.pushNamed(context, '/payment-method', arguments: {'plan': id, 'title': title, 'price': price});
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isThisPlanActive ? color : const Color(0xFFE5E7EB), width: isThisPlanActive ? 2 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                    if (isThisPlanActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: Text('CURRENT', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                    Padding(padding: const EdgeInsets.only(bottom: 4, left: 2), child: Text(period, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)))),
                  ],
                ),
                const Divider(height: 32),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [Icon(Icons.check_circle, color: color, size: 16), const SizedBox(width: 8), Expanded(child: Text(f, style: const TextStyle(fontSize: 14)))]),
                )),
                
                // Show Payment Details if Active
                if (isThisPlanActive && paymentInfo != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 8),
                        _infoRow('Method', paymentInfo['method'].toString().toUpperCase()),
                        _infoRow('Account', paymentInfo['details'] ?? 'N/A'),
                        _infoRow('Date', DateFormat('MMM d, yyyy').format((paymentInfo['timestamp'] as Timestamp).toDate())),
                        if (expiryDate != null)
                          _infoRow('Expiry', DateFormat('MMM d, yyyy').format(expiryDate.toDate()), isRed: expiryDate.toDate().difference(DateTime.now()).inDays < 5),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onMainPressed,
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                if (isThisPlanActive && id != 'free')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: TextButton(
                        onPressed: () => _cancelSubscription(context, uid!),
                        child: const Text('Cancel Subscription', style: TextStyle(color: Colors.red, decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isRed ? Colors.red : Colors.black87)),
        ],
      ),
    );
  }
}
