import 'dart:async';

import 'package:project_3_forex_signals_daily/core/models/purchase_details_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/view_models/auth_viewmodel.dart';
import 'package:project_3_forex_signals_daily/features/user_account/repositories/user_account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_active_subscriptions_viewmodel.g.dart';

@riverpod
class UserActiveSubscriptionsViewmodel
    extends _$UserActiveSubscriptionsViewmodel {
  late UserAccountRepository _userAccountRepository;
  StreamSubscription? _purchasesStreamSubscription;

  @override
  AsyncValue<List<PurchaseDetailsModel>> build() {
    _userAccountRepository = ref.watch(userAccountRepositoryProvider);

    // Watch the auth state and set up listener
    final authState = ref.watch(authViewModelProvider);

    // Handle auth state changes
    authState.whenData((user) {
      if (user != null) {
        setUpPurchasesListner(user.uid);
      }
    });

    // Clean up on dispose
    ref.onDispose(() {
      _purchasesStreamSubscription?.cancel();
    });

    // Return initial loading state or error if no user
    return authState.when(
      data: (user) => user != null
          ? const AsyncValue.loading()
          : AsyncValue.error('No user logged in', StackTrace.current),
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }

  // Keep track of purchases using a Map
  final Map<String, PurchaseDetailsModel?> _purchasesMap = {};

  Future<void> setUpPurchasesListner(String userId) async {
    // Cancel existing subscription if any
    await _purchasesStreamSubscription?.cancel();

    printDebug('=====> user active subs > getting active subs');
    _purchasesStreamSubscription =
        _userAccountRepository.purchasesStream(userId).listen(
      (snapshot) {
        try {
          final purchasesList = snapshot.docs
              .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                try {
                  final purchaseDetails = PurchaseDetailsModel.fromMap(data);
                  _purchasesMap[purchaseDetails.orderId] = purchaseDetails;
                  printDebug(
                      '=====> user active subs viewmodel : product id: ${purchaseDetails.productId}, status ${purchaseDetails.status}');
                  return purchaseDetails;
                } catch (e) {
                  printDebug(
                      '=====> user active subs viewmodel : Error converting doc to PurchaseDetailsModel: doc : ${doc.id}, Error : $e');
                  _purchasesMap.remove(doc.id);
                  return null;
                }
              })
              .whereType<PurchaseDetailsModel>()
              .toList();
          state = AsyncValue.data(purchasesList);
        } catch (e, stack) {
          state = AsyncValue.error(e, stack);
        }
      },
      onError: (error, stack) {
        state = AsyncValue.error(error, stack);
      },
    );
  }
}
