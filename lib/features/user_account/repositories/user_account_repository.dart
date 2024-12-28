import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/constants/constants.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_account_repository.g.dart';

@riverpod
UserAccountRepository userAccountRepository(Ref ref) {
  return UserAccountRepository();
}

class UserAccountRepository {
  late final FirebaseFirestore _firebaseFirestore;

  UserAccountRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createUserAccount(
    User user,
    String fcmToken,
    bool isAdmin,
  ) async {
    final userAccountDoc = _firebaseFirestore
        .collection(FirestoreCollections.userDbCollection)
        .doc(user.uid);

    printDebug('=====> user account repo : creating user account');

    final userdAccountData = UserAccountModel(
      id: user.uid,
      platform: defaultTargetPlatform.toString(),
      installedTimestamp: Timestamp.now().millisecondsSinceEpoch,
      isPremium: false,
      fcmToken: fcmToken,
      email: null,
      isAnonymous: true,
      isAdmin: null,
    ).toMap();
    try {
      await userAccountDoc.set(userdAccountData);
    } catch (e) {
      printDebug('=====> user account repo : error creating user account : $e');
    }
  }

  Stream<UserAccountModel?> userAccountStream(String userId) {
    return _firebaseFirestore
        .collection(FirestoreCollections.userDbCollection)
        .doc(userId)
        .snapshots()
        .map(
            (doc) => doc.exists ? UserAccountModel.fromMap(doc.data()!) : null);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> purchasesStream(String userId) {
    final purchasesStream = _firebaseFirestore
        .collection(FirestoreCollections.purchasesCollection)
        .where('userIds', arrayContains: userId)
        .where('status', isEqualTo: 'ACTIVE')
        .snapshots();
    return purchasesStream;
  }

  Future<void> updateExistingUserDoc(User user) async {
    final updates = {
      'isAnonymous': false,
      'email': user.email,
    };

    try {
      await _firebaseFirestore
          .collection(FirestoreCollections.userDbCollection)
          .doc(user.uid)
          .set(updates, SetOptions(merge: true));
    } catch (e) {
      printDebug('=====> error updating firestore user account : $e ');
    }
  }

  Future<void> updateFcmToken(String userUid, String fcmToken) async {
    final userAccountDoc = _firebaseFirestore
        .collection(FirestoreCollections.userDbCollection)
        .doc(userUid);
    await userAccountDoc.set(
      {'fcmToken': fcmToken},
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> updatePremiumState(String userUid) async {
    final userAccountDoc = _firebaseFirestore
        .collection(FirestoreCollections.userDbCollection)
        .doc(userUid);
    await userAccountDoc.set(
      {'isPremium': false},
      SetOptions(
        merge: true,
      ),
    );
  }

  // Future<void> updateEmail(String userUid, String email) async {
  //   final userAccountDoc = _firebaseFirestore
  //       .collection(FirestoreCollections.userDbCollection)
  //       .doc(userUid);
  //   await userAccountDoc.set(
  //     {'email': email},
  //     SetOptions(
  //       merge: true,
  //     ),
  //   );
  // }

  Future<bool> isAdmin(String userUid) async {
    final isAdminDoc = _firebaseFirestore
        .collection(FirestoreCollections.adminCollection)
        .doc(userUid);
    try {
      final snap = await isAdminDoc.get();
      if (snap.exists) {
        printDebug('=====> admin exists');
        return true;
      }
    } catch (e) {
      printDebug('=====> error getting isAdmin doc : $e');
      return false;
    }

    return false;
  }
}
