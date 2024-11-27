import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:project_3_forex_signals_daily/core/constants/constants.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'in_app_products_repository.g.dart';

@riverpod
InAppProductsRepository inAppProductsRepository(Ref ref) {
  return InAppProductsRepository();
}

class InAppProductsRepository {
  final InAppPurchase _inAppPurchase;

  InAppProductsRepository({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  Future<Either<AppFailure, List<ProductDetails>>>
      loadProductDetailsList() async {
    try {
      final bool isAvailable = await _inAppPurchase.isAvailable();
      printDebug('=====> iap repo : is available : $isAvailable');
      if (isAvailable) {
        try {
          final ProductDetailsResponse response =
              await _inAppPurchase.queryProductDetails(regularInAppProductIds);
          printDebug(
              '=====> iap repo : #products : ${response.productDetails.length}');
          return Right(response.productDetails);
        } catch (e) {
          printDebug('=====> iap repo : loadProducts error : $e');
          return Left(AppFailure(e.toString()));
        }
      } else {
        return Left(AppFailure('store not available'));
      }
    } catch (e) {
      printDebug('=====> iap repo : iap error : $e');
      return Left(AppFailure(e.toString()));
    }
  }
}
