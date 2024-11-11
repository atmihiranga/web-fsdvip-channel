import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/connectivity_check/repositories/connectivity_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'connectivity_check_viewmodell.g.dart';

@riverpod
class ConnectivityViewModel extends _$ConnectivityViewModel {
  // we instantiate ConnectivityRepository late inside the build function  with
  // ConnectivityRepository exposed through a provider, so that it is aware of the changes in the ConnectivityRepository
  // explaination : https://youtu.be/CWvlOU2Y3Ik?t=13716
  late final ConnectivityRepository _connectivityRepository;
  StreamSubscription? _connectivitySubscription;

  @override
  AsyncValue<bool> build() {
    _connectivityRepository = ref.watch(connectivityRepositoryProvider);

    // Start listening to connectivity changes
    _setupConnectivityListener();

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    return const AsyncValue.loading();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivityRepository
        .connectivityStatus()
        .listen((connectivityResult) {
      printDebug(
          '=====> connectivity_check_viewmodel : Connectivity Changed: $connectivityResult');

      // Update state based on connectivity result
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);
      state = AsyncValue.data(isConnected);
    });
  }
}
