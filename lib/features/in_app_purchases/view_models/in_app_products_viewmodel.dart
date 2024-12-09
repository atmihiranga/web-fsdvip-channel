import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/repositories/in_app_products_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'in_app_products_viewmodel.g.dart';

@riverpod
class InAppProductsViewModel extends _$InAppProductsViewModel {
  late InAppProductsRepository _inAppProductsRepository;
  @override
  AsyncValue<List<ProductDetails>> build() {
    _inAppProductsRepository = ref.watch(inAppProductsRepositoryProvider);
    _loadProductDetailsList();
    return AsyncValue.loading();
  }

  Future<void> _loadProductDetailsList() async {
    final productDetailsResult =
        await _inAppProductsRepository.loadProductDetailsList();
    state = switch (productDetailsResult) {
      Left(value: final l) => AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => AsyncValue.data(r)
    };
  }
}
