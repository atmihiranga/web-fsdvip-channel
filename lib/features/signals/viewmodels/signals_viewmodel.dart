import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/signals/repositories/signals_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'signals_viewmodel.g.dart';

@riverpod
class SignalsViewmodel extends _$SignalsViewmodel {
  late SignalsRepository _signalsRepository;
  StreamSubscription? _signalsSubscription;
  // Keep track of signals using a Map to prevent duplicates
  final Map<String, SignalModel?> _signalsMap = {};
  DocumentSnapshot? _lastFirestoreSignalDocument;
  bool _isFetchingMoreSignalDocuments = false;
  bool _hasMoreData = true;

  @override
  AsyncValue<List<SignalModel?>> build() {
    _signalsRepository = ref.watch(signalsRepositoryProvider);
    _setupFirestoreSignalsListner();

    // Dispose of the subscription when the provider is disposed
    ref.onDispose(() {
      _signalsSubscription?.cancel();
    });
    return AsyncValue.loading();
  }

  void _setupFirestoreSignalsListner() {
    _signalsSubscription?.cancel();
    _signalsSubscription = _signalsRepository.signalStream().listen((snapshot) {
      printDebug('=====> signals_viewmodel : data changed');
      // below code will convert QuerySnapshot<Map<String, dynamic>> to a List<SignalModel?> and save in signalList variable
      final signalList = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal =
                  SignalModel.fromMap(data).copyWith(isExpanded: false);
              _signalsMap[signal.id] = signal;
              printDebug(
                  '=====> signals_viewmodel : signal id: ${signal.id}, ${signal.isExpanded}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> signals_viewmodel : Error converting doc to SignalModel: doc : ${doc.id}, Error : $e');
              _signalsMap.remove(doc.id);
              return null;
            }
          })
          .whereType<SignalModel>() // Filters out nulls and casts the list
          .toList();

      // Update _lastDocument for pagination
      if (signalList.isNotEmpty && _lastFirestoreSignalDocument == null) {
        _lastFirestoreSignalDocument = snapshot.docs.last;
      }
      // sort signal list by timestamp
      signalList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      state = AsyncValue.data(signalList);
    });
  }

  Future<void> fetchMoreSignals() async {
    if (_isFetchingMoreSignalDocuments || !_hasMoreData) return;
    if (_lastFirestoreSignalDocument == null) return;

    _isFetchingMoreSignalDocuments = true;
    try {
      printDebug(
          '=====> fetching more from doc : ${_lastFirestoreSignalDocument?.id}');
      final querySnapshot = await _signalsRepository.fetchNextSignals(
        lastDocument: _lastFirestoreSignalDocument!,
        limit: 8,
      );

      final newSignals = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal = SignalModel.fromMap(data);
              _signalsMap[signal.id] = signal;
              printDebug('=====> signals_viewmodel : signal id: ${signal.id}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> signals_viewmodel : Error converting document to SignalModel: $e');
              return null;
            }
          })
          .whereType<SignalModel>() // Filters out nulls and casts the list
          .toList();

      final updatedSignalList = _signalsMap.values.toList();
      // sort signal list by timestamp
      updatedSignalList.sort((a, b) => b!.timestamp.compareTo(a!.timestamp));

      if (newSignals.isNotEmpty) {
        _lastFirestoreSignalDocument = querySnapshot.docs.last;
        state = AsyncValue.data(updatedSignalList);
      } else {
        _hasMoreData = false;
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isFetchingMoreSignalDocuments = false;
    }
  }

  Future<void> updateSignal(SignalModel updatedSignal) async {
    final existingSignal = _signalsMap[updatedSignal.id];
    if (existingSignal == null) {
      printDebug('=====> signals_viewmodel : Signal not found locally.');
      return;
    }
    // Convert updatedSignal and existingSignal to maps for comparison
    final updatedMap = updatedSignal.toMap();
    final existingMap = existingSignal.toMap();

    // Remove unchanged properties
    updatedMap.removeWhere((key, value) => existingMap[key] == value);

    if (updatedMap.isEmpty) {
      printDebug('=====> signals_viewmodel : No changes detected.');
      return;
    }

    state = AsyncValue.loading();
    await _signalsRepository.updateSignalDoc(updatedSignal.id, updatedMap);
  }

  Future<void> deleteSignal(SignalModel signal) async {
    String docId = signal.id;
    await _signalsRepository.deleteSignalDoc(docId);
  }

  void changeIsExpanded() {}
}
