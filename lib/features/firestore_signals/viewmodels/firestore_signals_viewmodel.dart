import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/firestore_signals/repositories/firestore_signals_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firestore_signals_viewmodel.g.dart';

@riverpod
class FirestoreSignalsViewmodel extends _$FirestoreSignalsViewmodel {
  late final FirestoreSignalsRepository _firestoreSignalsRepository;
  StreamSubscription? _firestoreSignalsSubscription;
  // Keep track of signals using a Map to prevent duplicates
  final Map<String, SignalModel?> _signalsMap = {};
  DocumentSnapshot? _lastDocument;
  bool _isFetchingMore = false;
  bool _hasMoreData = true;

  @override
  AsyncValue<List<SignalModel?>> build() {
    _firestoreSignalsRepository = ref.watch(firestoreSignalsRepositoryProvider);
    _setupFirestoreSignalsListner();

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _firestoreSignalsSubscription?.cancel();
    });
    return AsyncValue.loading();
  }

  void _setupFirestoreSignalsListner() {
    _firestoreSignalsSubscription?.cancel();
    _firestoreSignalsSubscription =
        _firestoreSignalsRepository.signalStream().listen((snapshot) {
      printDebug('=====> firestore_signals_viewmodel : data changed');
      // below code will convert QuerySnapshot<Map<String, dynamic>> to a List<SignalModel?> and save in signalList variable
      final signalList = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal = SignalModel.fromMap(data);
              _signalsMap[signal.id] = signal;
              printDebug(
                  '=====> firestore_signals_viewmodel : signal id: ${signal.id}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> firestore_signals_viewmodel : Error converting doc to SignalModel: doc : ${doc.id}, Error : $e');
              _signalsMap.remove(doc.id);
              return null;
            }
          })
          .whereType<SignalModel>() // Filters out nulls and casts the list
          .toList();

      // Update _lastDocument for pagination
      if (signalList.isNotEmpty && _lastDocument == null) {
        _lastDocument = snapshot.docs.last;
      }
      // sort signal list by timestamp
      signalList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      state = AsyncValue.data(signalList);
    });
  }

  Future<void> fetchMoreSignals() async {
    if (_isFetchingMore || !_hasMoreData) return;
    if (_lastDocument == null) return;

    _isFetchingMore = true;
    try {
      printDebug('=====> fetching more from doc : ${_lastDocument?.id}');
      final querySnapshot = await _firestoreSignalsRepository.fetchNextSignals(
        lastDocument: _lastDocument!,
        limit: 8,
      );

      final newSignals = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal = SignalModel.fromMap(data);
              _signalsMap[signal.id] = signal;
              printDebug(
                  '=====> firestore_signals_viewmodel : signal id: ${signal.id}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> firestore_signals_viewmodel : Error converting document to SignalModel: $e');
              return null;
            }
          })
          .whereType<SignalModel>() // Filters out nulls and casts the list
          .toList();

      final updatedSignalList = _signalsMap.values.toList();
      // sort signal list by timestamp
      updatedSignalList.sort((a, b) => b!.timestamp.compareTo(a!.timestamp));

      if (newSignals.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        state = AsyncValue.data(updatedSignalList);
      } else {
        _hasMoreData = false;
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> updateSignal(SignalModel updatedSignal) async {
    final existingSignal = _signalsMap[updatedSignal.id];
    if (existingSignal == null) {
      printDebug(
          '=====> firestore_signals_viewmodel : Signal not found locally.');
      return;
    }
    final updates = updatedSignal.toMap();
    _firestoreSignalsRepository.updateSignalDoc(updatedSignal.id, updates);
  }
}
