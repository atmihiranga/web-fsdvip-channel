import 'dart:async';

import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/firestore_signals/repositories/firestore_signals_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firestore_signals_viewmodel.g.dart';

@riverpod
class FirestoreSignalsViewmodel extends _$FirestoreSignalsViewmodel {
  late final FirestoreSignalsRepository _firestoreSignalsRepository;
  StreamSubscription? _firestoreSignalsSubscription;

  @override
  AsyncValue<List<SignalModel?>> build() {
    _firestoreSignalsRepository = ref.watch(firestoreSignalsRepositoryProvider);
    _setupSignalsListner();

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _firestoreSignalsSubscription?.cancel();
    });
    return AsyncValue.loading();
  }

  void _setupSignalsListner() {
    _firestoreSignalsSubscription?.cancel();
    _firestoreSignalsSubscription =
        _firestoreSignalsRepository.signalStream().listen((snapshot) {
      printDebug('=====> data changed');
      final signalList = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        printDebug('=====> doc id : ${doc.id}');
        try {
          final signal = SignalModel.fromMap(data);
          return signal;
        } catch (e) {
          printDebug('=====> Error converting document to SignalModel: $e');
          return null; // Return null
        }
      }).toList();
      state = AsyncValue.data(signalList);
    });
  }
}
