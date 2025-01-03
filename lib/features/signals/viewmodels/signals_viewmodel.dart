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
  bool _isInitiailActiveSignalUpdate = true;

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
    _signalsSubscription =
        _signalsRepository.activeSignalsStream().listen((snapshot) {
      printDebug('=====> signals vm : data changed');
      // below code will convert QuerySnapshot<Map<String, dynamic>> to a List<SignalModel?> and save in signalList variable
      final signalList = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal =
                  SignalModel.fromMap(data).copyWith(isExpanded: false);
              printDebug('=====> signals vm : symbol : ${signal.toString()}');
              _signalsMap[signal.id] = signal;

              return signal;
            } catch (e) {
              printDebug(
                  '=====> signals vm : Error converting doc to SignalModel: doc : ${doc.id}, Error : $e');
              _signalsMap.remove(doc.id);
              return null;
            }
          })
          .whereType<SignalModel>() // Filters out nulls and casts the list
          .toList();

      // sort signal list by timestamp
      signalList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (_isInitiailActiveSignalUpdate) {
        printDebug(
            '=====> signals vm > initial active signals stream update > updated docs : ${signalList.length}');
        fetchInitialInactiveSignals();
        _isInitiailActiveSignalUpdate = false;
      } else {
        printDebug(
            '=====> signals vm > active signals stream update > updated docs : ${signalList.length}');
        if (signalList.isEmpty) {
          printDebug(
              '=====> signals vm > active signals list is empty after update');
          _signalsMap.forEach((key, signal) {
            if (signal?.isActive == true) {
              _signalsMap[key] = signal?.copyWith(isActive: false);
            }
          });
        }
        printDebug(
            '=====> signals vm > setting signals state with updated signal map');
        final updatedSignalList = _signalsMap.values.toList();
        // sort signal list by timestamp
        updatedSignalList.sort((a, b) => b!.timestamp.compareTo(a!.timestamp));
        state = AsyncValue.data(updatedSignalList);
      }
    });
  }

  Future<void> fetchInitialInactiveSignals() async {
    try {
      printDebug('=====> signals vm > fetching initial inactive signals');
      final querySnapshot =
          await _signalsRepository.fetchInitialInactiveSignals(
        limit: 10,
      );

      final newSignals = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal =
                  SignalModel.fromMap(data).copyWith(isExpanded: false);
              _signalsMap[signal.id] = signal;
              // printDebug('=====> signals_viewmodel : signal id: ${signal.id}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> signals vm > Error converting document to SignalModel: $e');
              return null;
            }
          })
          .whereType<SignalModel>() // Filters out nulls and casts the list
          .toList();
      printDebug(
          '=====> signals vm > fetched initial inactive signals, docs : ${newSignals.length} ');
      final updatedSignalList = _signalsMap.values.toList();
      // sort signal list by timestamp
      updatedSignalList.sort((a, b) => b!.timestamp.compareTo(a!.timestamp));

      if (newSignals.isNotEmpty) {
        _lastFirestoreSignalDocument = querySnapshot.docs.last;
        printDebug(
            '=====> signals vm > setting signals state with initial active signals and inactive signals');
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

  Future<void> fetchMoreSignals() async {
    if (_isFetchingMoreSignalDocuments || !_hasMoreData) return;
    if (_lastFirestoreSignalDocument == null) return;

    _isFetchingMoreSignalDocuments = true;
    try {
      printDebug(
          '=====> signals vm > fetching 8 more on scroll, starting from doc : ${_lastFirestoreSignalDocument?.id}');
      final querySnapshot = await _signalsRepository.fetchNextInactiveSignals(
        lastDocument: _lastFirestoreSignalDocument!,
        limit: 8,
      );

      final newSignals = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            try {
              final signal =
                  SignalModel.fromMap(data).copyWith(isExpanded: false);
              _signalsMap[signal.id] = signal;
              printDebug('=====> signals vm : signal id: ${signal.id}');
              return signal;
            } catch (e) {
              printDebug(
                  '=====> signals vm : Error converting document to SignalModel: $e');
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
    printDebug('=====> signals_viewmodel : updating signal');
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
}
