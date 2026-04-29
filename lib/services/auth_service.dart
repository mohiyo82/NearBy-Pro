import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '965767919189-90inlbdjhkk0kbbfpteijfdqddoelmo6.apps.googleusercontent.com',
  );

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Record Session Details ───
  Future<void> _recordSession(String uid) async {
    try {
      String locationName = "Unknown Location";
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          locationName = "${place.locality}, ${place.subAdministrativeArea}";
        }
      } catch (_) {}

      String deviceName = Platform.isAndroid ? "Android Device" : "iOS Device";
      String deviceId = uid + DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore.collection('users').doc(uid).collection('sessions').add({
        'id': deviceId,
        'deviceName': deviceName,
        'deviceType': 'phone',
        'location': locationName,
        'lastActive': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'isCurrentDevice': true,
        'ipAddress': '192.168.1.1', // Placeholder
      });
    } catch (e) {
      print("Error recording session: $e");
    }
  }

  // ─── Google Sign In ───
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? 'New User',
          'email': userCredential.user!.email ?? '',
          'phone': userCredential.user!.phoneNumber ?? '',
          'profileImage': userCredential.user!.photoURL ?? '',
          'userType': 'other',
          'bio': '',
          'followersCount': 0, // Initialized
          'followingCount': 0, // Initialized
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      _recordSession(userCredential.user!.uid);
      return userCredential;
    } catch (e) {
      print('Google Sign-In Error Details: $e');
      rethrow; 
    }
  }

  // ─── Secure Delete Account ───
  Future<void> deleteAccount(String password) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: password);
    await user.reauthenticateWithCredential(credential);
    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
    String? dob,
    String? profileImage,
    String? bio,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'userType': userType,
      'dob': dob,
      'profileImage': profileImage,
      'bio': bio ?? '',
      'followersCount': 0, // Initialized
      'followingCount': 0, // Initialized
      'createdAt': FieldValue.serverTimestamp(),
    });
    _recordSession(userCredential.user!.uid);
    return userCredential;
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    _recordSession(userCredential.user!.uid);
    return userCredential;
  }

  Future<void> signOut() async {
    try { await _googleSignIn.signOut(); } catch (_) {}
    await _auth.signOut();
  }

  Stream<DocumentSnapshot> userDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
