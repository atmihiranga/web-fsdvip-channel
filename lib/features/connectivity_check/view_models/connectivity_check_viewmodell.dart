import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/repositories/connectivity_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'connectivity_check_viewmodell.g.dart';

@riverpod
class ConnectivityViewModel extends _$ConnectivityViewModel {
  late final ConnectivityRepository _connectivityRepository;
  @override
  AsyncValue<bool> build() {
    _connectivityRepository = ref.watch(connectivityRepositoryProvider);
    checkInternetConnectivity();
    return const AsyncValue.loading();
  }

  Future<void> checkInternetConnectivity() async {
    printDebug('=====> Checking internet connectivity');
    state = const AsyncValue.loading();
    final result = await _connectivityRepository.checkConnectivity();
    printDebug('=====> Result: $result');
    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    printDebug('=====> Val: $val');
  }
}
