import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure.dart';
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

  Future<Either<AppFailure, UserAccountModel>> getOrCreateUserAccount(
      User user, String fcmToken) async {
    try {
      printDebug('=====> user account repo : tryng to get user acc');
      final userAccountDoc =
          _firebaseFirestore.collection('userdb').doc(user.uid);
      final userAccountSnap = await userAccountDoc.get();
      if (userAccountSnap.exists) {
        final userdAccountData = userAccountSnap.data() as Map<String, dynamic>;
        // return user account
        printDebug('=====> user account repo : user account exists');
        final userAccount = UserAccountModel.fromMap(userdAccountData);

        if (userAccount.isAnonymous && !user.isAnonymous) {
          printDebug(
              '=====> user account repo : existing user is anonymous, auth user is not anonymous ');
          updateExistingUser(user);
        }
        return Right(userAccount);
      } else {
        printDebug(
            '=====> user account repo : user account doc dont exist, creating user account');
        // create user if user does not exist

        final userdAccountData = UserAccountModel(
          id: user.uid,
          platform: defaultTargetPlatform.toString(),
          installedTimestamp: Timestamp.now().millisecondsSinceEpoch,
          isPremium: false,
          fcmToken: fcmToken,
          email: '',
          isAnonymous: true,
        ).toMap();
        try {
          await userAccountDoc.set(userdAccountData);
          final userAccount = UserAccountModel.fromMap(userdAccountData);
          return Right(userAccount);
        } catch (e) {
          printDebug(
              '=====> user account repo : error creating user account : $e');
          return Left(AppFailure(e.toString()));
        }
      }
    } catch (e) {
      printDebug('=====> user account repo : error getting user account : $e');
      return Left(AppFailure(e.toString()));
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userAccountStream(
      String userId) {
    return _firebaseFirestore
        .collection('userdb')
        // .where('isActive', isEqualTo: true)
        .doc(userId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> purchasesStream(String userId) {
    final purchasesStream = _firebaseFirestore
        .collection('purchases')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'ACTIVE')
        .snapshots();
    return purchasesStream;
  }

  Future<void> updateExistingUser(User user) async {
    final userAccountDoc =
        _firebaseFirestore.collection('userdb').doc(user.uid);
    await userAccountDoc.set(
      {
        'isAnonymous': false,
        'email': user.email,
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> setOrUpdateFcmToken(String userUid, String fcmToken) async {
    final userAccountDoc = _firebaseFirestore.collection('userdb').doc(userUid);
    await userAccountDoc.set(
      {'fcmToken': fcmToken},
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> updateUser() async {}
}
