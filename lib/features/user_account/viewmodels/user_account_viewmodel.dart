import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/anonymous_auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/firebase_cloud_messaging/repositories/firebase_cloud_messaging_repository.dart';
import 'package:project_3_forex_signals_daily/features/firebase_cloud_messaging/viewmodels/firebase_cloud_messaging_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/user_account/repositories/user_account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_account_viewmodel.g.dart';

@riverpod
class UserAccountViewmodel extends _$UserAccountViewmodel {
  late UserAccountRepository _userAccountRepository;
  StreamSubscription? _userAccountUpdatesSubscription;

  @override
  AsyncValue<UserAccountModel> build() {
    // Watch the AnonymousAuthViewModel to get the current user
    final authState = ref.watch(anonymousAuthViewModelProvider);

    _userAccountRepository = ref.watch(userAccountRepositoryProvider);
    authState.when(
      data: (user) {
        // You now have access to the authenticated user
        if (user != null) {
          String userUid = user.uid;
          getUserAccount(userUid);
          return AsyncValue.loading();
        } else {
          return AsyncValue.error('Error : User is null', StackTrace.current);
        }
      },
      loading: () {
        // Handle loading state
        return const AsyncValue.loading();
      },
      error: (error, stackTrace) {
        // Handle error state
        return AsyncValue.error(error, stackTrace);
      },
    );

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _userAccountUpdatesSubscription?.cancel();
    });
    return AsyncValue.loading();
  }

  Future<void> getUserAccount(String userUid) async {
    // for now we set fcmToken as '' because to get fcmTokenwe user have to accept notification permissions.
    // after that we can get and set the token in firestore user doc
    final String fcmToken = '';

    try {
      final userResult = await _userAccountRepository.getOrCreateUserAccount(
          userUid, fcmToken);

      if (userResult case Left(value: final l)) {
        state = AsyncValue.error(l, StackTrace.current);
      } else if (userResult case Right(value: final r)) {
        state = AsyncValue.data(r);
        listenToUserAccountUpdates(userUid);
      }
    } catch (e, stackTrace) {
      printDebug('=====> user account repo : error getting user');
      AsyncValue.error(e, stackTrace);
    }
  }

  void listenToUserAccountUpdates(String userId) {
    _userAccountUpdatesSubscription =
        _userAccountRepository.userAccountStream(userId).listen((docSnapshot) {
      printDebug('=====> user account updated ');
      final userdAccountData = docSnapshot.data() as Map<String, dynamic>;
      final userAccount = UserAccountModel.fromMap(userdAccountData);
      state = AsyncValue.data(userAccount);
    });
  }

  //UserAccountModel getCurrentUserAccount() {}

  // when googl sign in is implemented, write a method like below to reset the state when user signout
  void resetState() {
    state = AsyncValue.data(UserAccountModel(
        id: '',
        platform: defaultTargetPlatform.toString(),
        installedTimestamp: 0,
        isPremium: false,
        fcmToken: ''));
  }
}
