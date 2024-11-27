import 'package:project_3_forex_signals_daily/features/in_app_purchases/repositories/in_app_purchase_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_app_purchase_view_model.g.dart';

@riverpod
class InAppPurchaseViewModel extends _$InAppPurchaseViewModel {
  late final InAppPurchaseRepository inAppPurchaseRepository;

  @override
  void build() {
    inAppPurchaseRepository = ref.watch(inAppPurchaseRepositoryProvider);

    _setupPurchaseUpdatesListner();
  }

  void _setupPurchaseUpdatesListner() {}
}
