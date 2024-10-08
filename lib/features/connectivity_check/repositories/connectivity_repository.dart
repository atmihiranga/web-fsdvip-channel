import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_repository.g.dart';

@riverpod
ConnectivityRepository connectivityRepository(ConnectivityRepositoryRef ref) {
  return ConnectivityRepository();
}

class ConnectivityRepository {
  final Connectivity _connectivity = Connectivity();

  Future<Either<AppFailure, bool>> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      bool isConnected = false;
      if (!result.contains(ConnectivityResult.none)) {
        isConnected = true;
      }
      return Right(isConnected);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
