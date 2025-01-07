import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/models/data_points.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'signal_stats_repository.g.dart';

@riverpod
SignalStatsRepository signalStatsRepository(Ref ref) {
  return SignalStatsRepository();
}

class SignalStatsRepository {
  final FirebaseFirestore _firebaseFirestore;

  SignalStatsRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> updateStats() async {
    // 1. Reference the collection that contains your documents
    final signalCollectionRef = _firebaseFirestore.collection('signaldb');

    // 2. Get all documents in that collection
    final querySnapshot = await signalCollectionRef.get();

    // 3. Initialize variables for tracking statistics
    final Map<String, double> resultsMap = {};
    double profitPips = 0;
    double lossPips = 0;
    int slHit = 0;
    int tp1Hit = 0;
    int tp2Hit = 0;
    int tp3Hit = 0;
    int closed = 0;

    // 4. Process each document
    for (final doc in querySnapshot.docs) {
      final data = doc.data();

      // Handle resultsMap data
      final timestamp = data['timestamp'];
      final result = data['result'];
      if (timestamp != null && result != null) {
        resultsMap[timestamp.toString()] = result.toDouble();

        // Calculate profit/loss pips
        double resultValue = result.toDouble();
        if (resultValue > 0) {
          profitPips += resultValue;
        } else {
          lossPips += resultValue;
        }
      }

      // Count various hit types
      if (data['isSlHit'] == true) slHit++;
      if (data['isTp1Hit'] == true) tp1Hit++;
      if (data['isTp2Hit'] == true) tp2Hit++;
      if (data['isTp3Hit'] == true) tp3Hit++;
      if (data['isActive'] == false) closed++;
    }

    // 5. Write all statistics to the 'common' collection
    final statsDocRef =
        _firebaseFirestore.collection('common').doc('signalstats');
    await statsDocRef.set({
      'resultsMap': resultsMap,
      'profitPips': profitPips,
      'lossPips': lossPips,
      'slHit': slHit,
      'tp1Hit': tp1Hit,
      'tp2Hit': tp2Hit,
      'tp3Hit': tp3Hit,
      'closed': closed,
    }, SetOptions(merge: true));

    printDebug('Stats document updated successfully!');
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchSignalStatsDoc() async {
    final statsDocRef =
        FirebaseFirestore.instance.collection('common').doc('signalstats');
    final docSnap = await statsDocRef.get();

    return docSnap;
  }
}
