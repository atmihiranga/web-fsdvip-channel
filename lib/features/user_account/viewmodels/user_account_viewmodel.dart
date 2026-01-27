import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_3_forex_signals_daily/core/models/user_account_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/user_account/repositories/user_account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_account_viewmodel.g.dart';

@riverpod
class UserAccountViewmodel extends _$UserAccountViewmodel {
  late UserAccountRepository _userAccountRepository;
  StreamSubscription? _userAccountSubscription;

  @override
  AsyncValue<UserAccountModel> build() {
    // Watch the AnonymousAuthViewModel to get the current user
    final authState = ref.watch(authViewModelProvider);
    _userAccountRepository = ref.watch(userAccountRepositoryProvider);
    authState.when(
      data: (user) {
        // You now have access to the authenticated user
        printDebug('=====> user acc vm > got auth user ');
        if (user != null) {
          _initializeUserAccount(user);
          return AsyncValue.loading();
        } else {
          return AsyncValue.error('Error : User is null', StackTrace.current);
        }
      },
      loading: () {
        return const AsyncValue.loading();
      },
      error: (error, stackTrace) {
        return AsyncValue.error(error, stackTrace);
      },
    );

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _userAccountSubscription?.cancel();
    });
    return AsyncValue.loading();
  }

  Future<void> _initializeUserAccount(User user) async {
    try {
      final isAdmin = await _userAccountRepository.isAdmin(user.uid);
      _subscribeToUserUpdates(user, isAdmin);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  void _subscribeToUserUpdates(User user, bool isAdmin) {
    _userAccountSubscription?.cancel();

    _userAccountSubscription =
        _userAccountRepository.userAccountStream(user.uid).listen(
              (userAccount) =>
                  _handleUserAccountUpdate(user, userAccount, isAdmin),
              onError: (e, stack) => state = AsyncError(e, stack),
            );
  }

  Future<void> _handleUserAccountUpdate(
    User user,
    UserAccountModel? userAccount,
    bool isAdmin,
  ) async {
    if (userAccount != null) {
      // user account exists
      printDebug('=====> user acc vm > handling existing user account update');
      if (!user.isAnonymous && userAccount.isAnonymous) {
        try {
          await _userAccountRepository.updateExistingUserDoc(user);
        } catch (e) {
          printDebug('=====> error updating existing user : $e');
        }
      }
      state = AsyncValue.data(userAccount.copyWith(isAdmin: isAdmin));
    } else {
      try {
        await _userAccountRepository.createUserAccount(user, '', isAdmin);
      } catch (e, stack) {
        state = AsyncError(e, stack);
      }
    }
  }

  Future<void> updateFcmToken(String userUid, String token) async {
    try {
      await _userAccountRepository.updateFcmToken(userUid, token);
    } catch (e) {
      // Consider how you want to handle FCM token update failures
      printDebug('Failed to update FCM token: $e');
    }
  }

  Future<void> updatePreiumStatus(String userUid) async {
    try {
      await _userAccountRepository.updatePremiumState(userUid);
    } catch (e) {
      // Consider how you want to handle FCM token update failures
      printDebug('Failed to update FCM token: $e');
    }
  }
}
