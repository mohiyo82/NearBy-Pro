import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  // ─── PROFILE VIEWS ──────────────────────────────────────────
  
  Future<void> logProfileView(String targetCompanyId) async {
    final currentUid = uid;
    // Don't count if company is viewing their own profile or if no user logged in
    if (currentUid == null || currentUid == targetCompanyId) return;

    final companyRef = _firestore.collection('users').doc(targetCompanyId);
    
    await companyRef.set({
      'profileViews': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  // ─── SEARCH HISTORY & TRENDING ──────────────────────────────
  
  Future<void> addSearchHistory(String query) async {
    final currentUid = uid;
    if (currentUid == null) return;
    
    final batch = _firestore.batch();
    
    final trendingRef = _firestore.collection('trending_searches').doc(query.toLowerCase());
    batch.set(trendingRef, {
      'term': query,
      'count': FieldValue.increment(1),
      'lastSearched': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final historyRef = _firestore.collection('users').doc(currentUid).collection('search_history').doc();
    batch.set(historyRef, {
      'query': query,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final userRef = _firestore.collection('users').doc(currentUid);
    batch.set(userRef, {
      'searchCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  Stream<QuerySnapshot> get searchHistoryStream {
    final currentUid = uid;
    if (currentUid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(currentUid)
        .collection('search_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<QuerySnapshot> get trendingSearchesStream {
    return _firestore
        .collection('trending_searches')
        .orderBy('count', descending: true)
        .limit(5)
        .snapshots();
  }

  // ─── SAVED ITEMS ───────────────────────────────────────────

  Future<void> toggleSavePlace(Map<String, dynamic> placeData) async {
    final currentUid = uid;
    if (currentUid == null) return;

    final docRef = _firestore.collection('users').doc(currentUid).collection('saved_places').doc(placeData['id']);
    final userRef = _firestore.collection('users').doc(currentUid);
    
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      await userRef.update({'savedPlacesCount': FieldValue.increment(-1)});
    } else {
      await docRef.set({
        ...placeData,
        'savedAt': FieldValue.serverTimestamp(),
      });
      await userRef.set({'savedPlacesCount': FieldValue.increment(1)}, SetOptions(merge: true));
    }
  }

  Future<void> toggleSaveJob(Map<String, dynamic> jobData) async {
    final currentUid = uid;
    if (currentUid == null) return;

    final docRef = _firestore.collection('users').doc(currentUid).collection('saved_jobs').doc(jobData['id']);
    final userRef = _firestore.collection('users').doc(currentUid);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      await userRef.update({'savedJobsCount': FieldValue.increment(-1)});
    } else {
      await docRef.set({
        ...jobData,
        'savedAt': FieldValue.serverTimestamp(),
      });
      await userRef.set({'savedJobsCount': FieldValue.increment(1)}, SetOptions(merge: true));
    }
  }

  Stream<QuerySnapshot> get savedPlacesStream {
    final currentUid = uid;
    if (currentUid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(currentUid)
        .collection('saved_places')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> get savedJobsStream {
    final currentUid = uid;
    if (currentUid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(currentUid)
        .collection('saved_jobs')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  Stream<bool> isJobSaved(String jobId) {
    final currentUid = uid;
    if (currentUid == null) return Stream.value(false);
    return _firestore
        .collection('users')
        .doc(currentUid)
        .collection('saved_jobs')
        .doc(jobId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // ─── JOB APPLICATIONS ───────────────────────────────────────

  Future<void> postJob(Map<String, dynamic> jobData) async {
    final currentUid = uid;
    if (currentUid == null) return;
    
    final companyDoc = await _firestore.collection('users').doc(currentUid).get();
    final companyName = companyDoc.data()?['companyName'] ?? companyDoc.data()?['name'] ?? 'A Company';
    final companyLogo = companyDoc.data()?['photoUrl'] ?? '';

    final jobRef = _firestore.collection('jobs').doc();
    final batch = _firestore.batch();

    batch.set(jobRef, {
      ...jobData,
      'id': jobRef.id,
      'companyId': currentUid,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
      'applicantCount': 0,
    });

    final postRef = _firestore.collection('posts').doc();
    batch.set(postRef, {
      'content': 'We are hiring: ${jobData['title']}! Location: ${jobData['location']}.',
      'authorId': currentUid,
      'authorName': companyName,
      'authorLogo': companyLogo,
      'authorType': 'company',
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'job',
      'jobId': jobRef.id,
      'likes': 0,
      'comments': 0,
    });

    await batch.commit();
  }

  Future<void> deleteJob(String jobId) async {
    final batch = _firestore.batch();
    batch.delete(_firestore.collection('jobs').doc(jobId));
    
    // Also delete the corresponding social post if it exists
    final posts = await _firestore.collection('posts').where('jobId', isEqualTo: jobId).get();
    for (var doc in posts.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> updates) async {
    await _firestore.collection('jobs').doc(jobId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> recordApplication(Map<String, dynamic> applicationData) async {
    final currentUid = uid;
    if (currentUid == null) return;

    final userDoc = await _firestore.collection('users').doc(currentUid).get();
    final userData = userDoc.data() as Map<String, dynamic>?;
    
    final batch = _firestore.batch();
    final jobId = applicationData['jobId'] ?? 'unknown';

    final appRef = _firestore.collection('jobs').doc(jobId).collection('applicants').doc(currentUid);
    batch.set(appRef, {
      'applicantUid': currentUid,
      'applicantPhoto': userData?['photoUrl'] ?? '',
      ...applicationData,
      'status': 'pending',
      'appliedAt': FieldValue.serverTimestamp(),
    });

    final userAppRef = _firestore.collection('users').doc(currentUid).collection('applications').doc(jobId);
    batch.set(userAppRef, {
      ...applicationData,
      'jobId': jobId,
      'status': 'pending',
      'appliedAt': FieldValue.serverTimestamp(),
    });

    batch.update(_firestore.collection('jobs').doc(jobId), {'applicantCount': FieldValue.increment(1)});
    batch.set(_firestore.collection('users').doc(currentUid), {'applicationsCount': FieldValue.increment(1)}, SetOptions(merge: true));

    await batch.commit();
  }

  Future<void> updateApplicationStatus(String jobId, String applicantUid, String newStatus) async {
    final batch = _firestore.batch();
    
    batch.update(_firestore.collection('jobs').doc(jobId).collection('applicants').doc(applicantUid), {
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(_firestore.collection('users').doc(applicantUid).collection('applications').doc(jobId), {
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // ─── FEED & POSTS ───────────────────────────────────────────

  Future<void> createPost(Map<String, dynamic> postData) async {
    final currentUid = uid;
    if (currentUid == null) return;
    await _firestore.collection('posts').add({
      ...postData,
      'authorId': currentUid,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0,
      'comments': 0,
    });
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  Future<void> updatePost(String postId, String content) async {
    await _firestore.collection('posts').doc(postId).update({
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    final currentUid = uid;
    if (currentUid == null) return;
    final postRef = _firestore.collection('posts').doc(postId);
    if (isLiked) {
      await postRef.update({'likes': FieldValue.increment(-1), 'likedBy': FieldValue.arrayRemove([currentUid])});
    } else {
      await postRef.update({'likes': FieldValue.increment(1), 'likedBy': FieldValue.arrayUnion([currentUid])});
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    final currentUid = uid;
    if (currentUid == null) return;
    final userDoc = await _firestore.collection('users').doc(currentUid).get();
    final name = userDoc.data()?['name'] ?? 'User';
    final photo = userDoc.data()?['photoUrl'] ?? '';
    
    await _firestore.collection('posts').doc(postId).collection('comments').add({
      'uid': currentUid, 'userName': name, 'userPhoto': photo, 'text': commentText, 'timestamp': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('posts').doc(postId).update({'comments': FieldValue.increment(1)});
  }

  // ─── FOLLOW SYSTEM ──────────────────────────────────────────

  Future<void> toggleFollow(String targetId, bool isFollowing) async {
    final currentUid = uid;
    if (currentUid == null) return;

    final batch = _firestore.batch();
    final myFollowingRef = _firestore.collection('users').doc(currentUid).collection('following').doc(targetId);
    final targetFollowersRef = _firestore.collection('users').doc(targetId).collection('followers').doc(currentUid);

    final myDocRef = _firestore.collection('users').doc(currentUid);
    final targetDocRef = _firestore.collection('users').doc(targetId);

    if (isFollowing) {
      batch.delete(myFollowingRef);
      batch.delete(targetFollowersRef);
      batch.update(myDocRef, {'followingCount': FieldValue.increment(-1)});
      batch.update(targetDocRef, {'followersCount': FieldValue.increment(-1)});
    } else {
      batch.set(myFollowingRef, {'followedAt': FieldValue.serverTimestamp()});
      batch.set(targetFollowersRef, {
        'followedAt': FieldValue.serverTimestamp(),
        'uid': currentUid,
      });
      batch.update(myDocRef, {'followingCount': FieldValue.increment(1)});
      batch.set(targetDocRef, {'followersCount': FieldValue.increment(1)}, SetOptions(merge: true));
    }

    await batch.commit();
  }

  // ─── QUICK STATS ────────────────────────────────────────────

  Stream<int> getCollectionCount(String collectionName) {
    final currentUid = uid;
    if (currentUid == null) return Stream.value(0);
    return _firestore.collection('users').doc(currentUid).snapshots().map((doc) {
      if (!doc.exists) return 0;
      final data = doc.data() as Map<String, dynamic>? ?? {};
      if (collectionName == 'search_history') return data['searchCount'] ?? 0;
      if (collectionName == 'saved_places') {
        final placesCount = data['savedPlacesCount'] ?? 0;
        final jobsCount = data['savedJobsCount'] ?? 0;
        return placesCount + jobsCount;
      }
      if (collectionName == 'applications') return data['applicationsCount'] ?? 0;
      if (collectionName == 'profile_views') return data['profileViews'] ?? 0;
      return 0;
    });
  }
}
