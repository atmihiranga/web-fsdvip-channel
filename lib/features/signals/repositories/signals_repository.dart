import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signals_repository.g.dart';

@riverpod
SignalsRepository signalsRepository(Ref ref) {
  return SignalsRepository();
}

class SignalsRepository {
  final FirebaseFirestore _firebaseFirestore;

  SignalsRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

// TODO : since we only listen to the changes of first 10 items, we won't recieve updates on next items when we update the signal,
// this cause state to keep on loading state
  Stream<QuerySnapshot<Map<String, dynamic>>> signalStream() {
    return _firebaseFirestore
        .collection('signaldb')
        // .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> activeSignalsStream() {
    return _firebaseFirestore
        .collection('signaldb')
        .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchInitialInactiveSignals({
    required int limit,
  }) async {
    return await _firebaseFirestore
        .collection('signaldb')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchNextInactiveSignals({
    required DocumentSnapshot lastDocument,
    required int limit,
  }) async {
    return await _firebaseFirestore
        .collection('signaldb')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
  }

  Future<void> updateSignalDoc(String id, Map<String, dynamic> updates) async {
    try {
      printDebug('=====> signals repo : updating doc id : $id');
      printDebug('=====> signals repo : updates : ${updates.toString()}');

      await _firebaseFirestore.collection('signaldb').doc(id).update(updates);
    } catch (e) {
      printDebug('=====> signals repo update error : $e');
    }
  }

  Future<void> deleteSignalDoc(String docId) async {
    printDebug('=====> firestore signals repo : deleting doc...');

    try {
      await _firebaseFirestore.collection('signaldb').doc(docId).delete();
      printDebug('=====> firestore signals repo : delete success}');
    } catch (e) {
      printDebug('=====> firestore signals repo : delete eror${e.toString()}');
    }
  }
}
