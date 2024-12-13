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
    // Watch the AnonymousAuthViewModel to get the current user
    final authState = ref.watch(authViewModelProvider);
    _userAccountRepository = ref.watch(userAccountRepositoryProvider);

    authState.when(data: (user) {
      // You now have access to the authenticated user
      if (user != null) {
        String userUid = user.uid;
        setUpPurchasesListner(userUid);
      } else {
        return AsyncValue.error('Error : User is null', StackTrace.current);
      }
    }, error: (error, stackTrace) {
      return AsyncValue.error(error, stackTrace);
    }, loading: () {
      return AsyncValue.loading();
    });
    ref.onDispose(() {
      _purchasesStreamSubscription?.cancel();
    });
    return AsyncValue.loading();
  }

  // Keep track of signals using a Map to prevent duplicates
  final Map<String, PurchaseDetailsModel?> _purchasesMap = {};

  Future<void> setUpPurchasesListner(String userId) async {
    _purchasesStreamSubscription?.cancel;

    printDebug('=====> user active subs > getting active subs');
    _purchasesStreamSubscription =
        _userAccountRepository.purchasesStream(userId).listen((snapshot) {
      // below code will convert QuerySnapshot<Map<String, dynamic>> to a List<SignalModel?> and save in signalList variable
      final purchasesList = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal = PurchaseDetailsModel.fromMap(data);
              _purchasesMap[signal.orderId] = signal;
              printDebug(
                  '=====> signals_viewmodel : signal id: ${signal.productId}, ${signal.status}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> signals_viewmodel : Error converting doc to SignalModel: doc : ${doc.id}, Error : $e');
              _purchasesMap.remove(doc.id);
              return null;
            }
          })
          .whereType<
              PurchaseDetailsModel>() // Filters out nulls and casts the list
          .toList();
      state = AsyncValue.data(purchasesList);
    });
  }
}
