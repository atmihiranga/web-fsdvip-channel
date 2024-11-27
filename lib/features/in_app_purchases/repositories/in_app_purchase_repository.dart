import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_app_purchase_repository.g.dart';

@riverpod
InAppPurchaseRepository inAppPurchaseRepository(Ref ref) {
  return InAppPurchaseRepository();
}

class InAppPurchaseRepository {
  final InAppPurchase _inAppPurchase;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  InAppPurchaseRepository({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  // Future<Either<AppFailure, List<PurchaseDetails>>>
  Future<void> listenToPurchaseUpdates() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      printDebug('=====> iap repo : is available : $isAvailable');
      if (isAvailable) {
        _subscription = _inAppPurchase.purchaseStream.listen(
          (purchaseDetailsList) {
            _handlePurchaseUpdate(purchaseDetailsList);
          },
          onDone: () => _subscription?.cancel(),
          onError: (error, stack) {},
        );
        //return Right(_inAppPurchase.purchaseStream);
      } else {
        //return Left(AppFailure('store not available'));
      }
    } catch (e) {
      printDebug('=====> iap repo : iap error : $e');
      //return Left(AppFailure('iap error'));
    }
  }

  Future<void> _handlePurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    List<PurchaseDetails> validPurchases = [];
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
                '=====> iap_repo : Purchase Updated : ${purchaseDetails.status}');

            bool valid = await _verifyPurchase(purchaseDetails);
            if (valid) {
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
          await _inAppPurchase.completePurchase(purchaseDetails);
          printDebug(
              '=====> iap_repo : Purchase Updated : purchaseDetails.pendingCompletePurchase completed');
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    //todo write verification code
    return true;
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
