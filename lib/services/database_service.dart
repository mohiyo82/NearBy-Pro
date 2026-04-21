import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  // ─── SEARCH HISTORY ──────────────────────────────────────────
  
  // Add search term to history
  Future<void> addSearchHistory(String query) async {
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('search_history').add({
      'query': query,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get search history stream
  Stream<QuerySnapshot> get searchHistoryStream {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('search_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  // ─── SAVED PLACES ───────────────────────────────────────────

  // Toggle save place
  Future<void> toggleSavePlace(Map<String, dynamic> placeData) async {
    if (uid == null) return;
    final docRef = _firestore.collection('users').doc(uid).collection('saved_places').doc(placeData['id']);
    
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        ...placeData,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Get saved places stream
  Stream<QuerySnapshot> get savedPlacesStream {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_places')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  // ─── QUICK STATS ────────────────────────────────────────────

  // Get counts for dashboard
  Stream<int> getCollectionCount(String collectionName) {
    if (uid == null) return Stream.value(0);
    return _firestore
        .collection('users')
        .doc(uid)
        .collection(collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
