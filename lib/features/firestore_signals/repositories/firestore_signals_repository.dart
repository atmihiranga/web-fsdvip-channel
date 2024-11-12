import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/core/models/signal_model.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_signals_repository.g.dart';

@riverpod
FirestoreSignalsRepository firestoreSignalsRepository(Ref ref) {
  return FirestoreSignalsRepository();
}

class FirestoreSignalsRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreSignalsRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> signalStream() {
    return _firebaseFirestore
        .collection('signaldb')
        // .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchNextSignals({
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
      printDebug('=====> setting id : $id');
      await _firebaseFirestore.collection('signaldb').doc(id).update(updates);
    } catch (e) {
      printDebug('=====> error : $e');
    }
  }
}
