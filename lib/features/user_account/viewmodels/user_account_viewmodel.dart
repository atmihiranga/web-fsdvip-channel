import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/auth_viewmodel.dart';
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
    final authState = ref.watch(authViewModelProvider);
    _userAccountRepository = ref.watch(userAccountRepositoryProvider);
    authState.when(
      data: (user) {
        // You now have access to the authenticated user
        if (user != null) {
          printDebug('=====> user account vm > name ${user.displayName}');
          getUserAccount(user);
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

  Future<void> getUserAccount(User user) async {
    String? fcmToken = await ref
        .read(firebaseCloudMessagingViewmodelProvider.notifier)
        .getFCMToken();

    try {
      final userResult = await _userAccountRepository.getOrCreateUserAccount(
        user,
        fcmToken ?? '',
      );

      if (userResult case Left(value: final l)) {
        state = AsyncValue.error(l, StackTrace.current);
      } else if (userResult case Right(value: final r)) {
        state = AsyncValue.data(r);
        listenToUserAccountUpdates(user.uid);
        ref.read(firebaseCloudMessagingViewmodelProvider);
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

  void setOrUpdateFcmToken(String userUid, String token) {
    _userAccountRepository.setOrUpdateFcmToken(userUid, token);
  }

  // when googl sign in is implemented, write a method like below to reset the state when user signout
  void resetState() {
    state = AsyncValue.data(UserAccountModel(
      id: '',
      platform: defaultTargetPlatform.toString(),
      installedTimestamp: 0,
      isPremium: false,
      fcmToken: '',
      authProvider: '',
      isAnonymous: true,
    ));
  }
}
