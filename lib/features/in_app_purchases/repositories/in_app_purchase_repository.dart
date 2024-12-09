import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

part 'in_app_purchase_repository.g.dart';

@riverpod
InAppPurchaseRepository inAppPurchaseRepository(Ref ref) {
  return InAppPurchaseRepository();
}

class InAppPurchaseRepository {
  final InAppPurchase _inAppPurchase;
  late Stream<List<PurchaseDetails>> _stream;

  InAppPurchaseRepository({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  Future<Either<AppFailure, Stream<List<PurchaseDetails>>>>
      getPurchaseUpdatesStream() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      printDebug('=====> iap repo : is available : $isAvailable');
      if (isAvailable) {
        _stream = _inAppPurchase.purchaseStream;
        return Right(_stream);
      } else {
        return Left(AppFailure('store not available'));
      }
    } catch (e) {
      printDebug('=====> iap repo : iap error : $e');
      return Left(AppFailure('iap error'));
    }
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) async {
    printDebug('=====> iap repo : verifying purchase');
    final verifier = FirebaseFunctions.instance.httpsCallable('verifyPurchase');
    final result = await verifier.call({
      'source': purchaseDetails.verificationData.source,
      'verificationData':
          purchaseDetails.verificationData.serverVerificationData,
      'productId': purchaseDetails.productID,
    });
    printDebug(
        "=====> iap repo : verification data : ${purchaseDetails.verificationData.serverVerificationData}");
    printDebug(
        '=====> iap repo : verifying purchase : result : ${result.data}');
    return result.data as bool;
  }

  Future<void> completePurchase(PurchaseDetails purchase) async {
    await _inAppPurchase.completePurchase(purchase);
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    // For iOS if the transaction is cancelled, it will leave a pending transaction.
    // So we have to Finish all pending transactions before buying new
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final paymentWrapper = SKPaymentQueueWrapper();
      final transactions = await paymentWrapper.transactions();
      for (var transaction in transactions) {
        await paymentWrapper.finishTransaction(transaction);
      }
    }
    try {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      printDebug('=====> $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      if (isAvailable) {
        printDebug('=====> iap repo > restore purchase > calling');
        await _inAppPurchase.restorePurchases();
      } else {
        printDebug('=====> iap repo > restore purchase > store not available');
      }
    } catch (e) {
      printDebug('=====> iap repo > restore purchase > store error : $e');
    }
  }
}
