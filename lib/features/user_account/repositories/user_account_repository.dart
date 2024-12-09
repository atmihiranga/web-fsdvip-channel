import 'package:cloud_firestore/cloud_firestore.dart';
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
      String userUid, String fcmToken) async {
    try {
      printDebug('=====> user account repo : tryng to get user acc');
      final userAccountDoc =
          _firebaseFirestore.collection('userdb').doc(userUid);
      final userAccountSnap = await userAccountDoc.get();
      if (userAccountSnap.exists) {
        final userdAccountData = userAccountSnap.data() as Map<String, dynamic>;
        // return user account
        printDebug('=====> user account repo : user account exists');
        final userAccount = UserAccountModel.fromMap(userdAccountData);
        return Right(userAccount);
      } else {
        printDebug(
            '=====> user account repo : user account doc dont exist, creating user account');
        // create user if user does not exist

        final userdAccountData = UserAccountModel(
                id: userUid,
                platform: defaultTargetPlatform.toString(),
                installedTimestamp: Timestamp.now().millisecondsSinceEpoch,
                isPremium: false,
                fcmToken: fcmToken)
            .toMap();
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

  Future<void> addUser() async {}

  Future<void> updateUser() async {}
}
