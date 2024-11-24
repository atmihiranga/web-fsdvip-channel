import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firestore_signal_stats.g.dart';

@riverpod
FirestoreSignalStats firestoreSignalStats(Ref ref) {
  return FirestoreSignalStats();
}

class FirestoreSignalStats {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreSignalStats({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<int> tp1Count() async {
    printDebug('=====> Tp1 count called');
    return await _firebaseFirestore
        .collection('signaldb')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .length;
  }
}
