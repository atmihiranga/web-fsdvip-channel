import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/repositories/in_app_purchase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_app_purchase_view_model.g.dart';

@Riverpod(keepAlive: true)
class InAppPurchaseViewModel extends _$InAppPurchaseViewModel {
  late final InAppPurchaseRepository _inAppPurchaseRepository;
  StreamSubscription? _purchaseUpdatesSubscription;

  @override
  AsyncValue<List<PurchaseDetails>> build() {
    _inAppPurchaseRepository = ref.watch(inAppPurchaseRepositoryProvider);
    _getPurchaseUpdateStream();

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _purchaseUpdatesSubscription?.cancel();
    });

    //restorePurchases();
    return AsyncValue.data(List.empty());
  }

  Future<void> _getPurchaseUpdateStream() async {
    printDebug('=====> iap viewmodel > getting stream');
    final streamResult =
        await _inAppPurchaseRepository.getPurchaseUpdatesStream();

    if (streamResult case Left(value: final l)) {
      printDebug('=====> iap viewmodel > getting stream : got left');
      state = AsyncValue.error(l, StackTrace.current);
    } else if (streamResult case Right(value: final r)) {
      printDebug('=====> iap viewmodel > getting stream : got right');
      _setupPurchaseUpdatesStream(r);
    }
  }

  void _setupPurchaseUpdatesStream(Stream<List<PurchaseDetails>> stream) {
    printDebug('=====> iap viewmodel > setting up stream');
    _purchaseUpdatesSubscription?.cancel();
    _purchaseUpdatesSubscription = stream.listen((onData) {
      printDebug('=====> iap viewmodel > stream subscription : data updated');
      _handlePurchaseUpdate(onData);
    });
  }

  Future<void> _handlePurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    printDebug('=====> iap viewmodel handing purchase update');
    final List<PurchaseDetails> validPurchases = [];
    if (purchaseDetailsList.isNotEmpty) {
      for (var purchaseDetails in purchaseDetailsList) {
        switch (purchaseDetails.status) {
          case PurchaseStatus.canceled:
            // ignore and continue
            continue;
          //case PurchaseStatus.pending:
          case PurchaseStatus.restored:
          case PurchaseStatus.purchased:
            // Handle restored/purchased/pending state
            printDebug(
                '=====> iap_repo : Purchase Updated : ${purchaseDetails.verificationData.localVerificationData}');

            bool valid =
                await _inAppPurchaseRepository.verifyPurchase(purchaseDetails);
            if (valid) {
              printDebug('=====> iap repo > adding to valid list');
              validPurchases.add(purchaseDetails);
            }

            break;
          case PurchaseStatus.error:
            // print and handle error
            printDebug(
                '=====> iap_repo : Purchase Updated : error : ${purchaseDetails.error}');
            break;
          default:
            // Handle other states if necessary
            break;
        }
        if (purchaseDetails.pendingCompletePurchase) {
          try {
            await _inAppPurchaseRepository.completePurchase(purchaseDetails);
          } catch (e) {
            printDebug('=====> iap repo : complete purchase error : $e');
          }
          printDebug(
              '=====> iap_repo : Purchase Updated : purchaseDetails.pendingCompletePurchase completed');
        }
      }
    }
    printDebug('=====> iap repo > valid list items : ${validPurchases.length}');
    state = AsyncValue.data(validPurchases);
  }

  Future<void> restorePurchases() async {
    state = AsyncValue.loading();
    await _inAppPurchaseRepository.restorePurchases();
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    state = AsyncValue.loading();
    await _inAppPurchaseRepository.buySubscription(productDetails);
  }
}
