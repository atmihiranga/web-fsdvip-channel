import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_repository.g.dart';

@riverpod
ConnectivityRepository connectivityRepository(Ref ref) {
  return ConnectivityRepository();
}

class ConnectivityRepository {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> connectivityStatus() {
    return _connectivity.onConnectivityChanged;
  }
}
