import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/signal_stats/models/data_points.dart';

class SignalStatsRepository {
  final FirebaseFirestore _firebaseFirestore;

  SignalStatsRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<Map<String, int?>> getSignalStats() async {
    final results = await Future.wait([
      _firebaseFirestore
          .collection('signaldb')
          .where('isSlHit', isEqualTo: true)
          .count()
          .get(),
      _firebaseFirestore
          .collection('signaldb')
          .where('isTp1Hit', isEqualTo: true)
          .count()
          .get(),
      _firebaseFirestore
          .collection('signaldb')
          .where('isTp2Hit', isEqualTo: true)
          .count()
          .get(),
      _firebaseFirestore
          .collection('signaldb')
          .where('isTp3Hit', isEqualTo: true)
          .count()
          .get(),
    ]);

    for (var element in results) {
      printDebug(element.count.toString());
    }

    return {
      'isSlHit': results[0].count,
      'isTp1Hit': results[1].count,
      'isTp2Hit': results[2].count,
      'isTp3Hit': results[3].count,
    };
  }

  Future<double> getTotalProfit() async {
    // 1. Reference your collection
    final collectionRef = _firebaseFirestore.collection('signaldb');

    // 2. Get all documents
    final querySnapshot = await collectionRef.get();

    // 3. Sum up the profit fields
    double totalProfit = 0;
    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      // Make sure you cast the field to a double (or int) appropriately
      final profit = data['result'] is int
          ? (data['result'] as int).toDouble()
          : data['result'] as double;
      totalProfit += profit;
    }

    printDebug(' profit : $totalProfit');

    return totalProfit;
  }

  Future<void> createStatsDocument() async {
    // 1. Reference the collection that contains your documents
    final originalCollectionRef =
        FirebaseFirestore.instance.collection('signaldb');

    // 2. Get all documents in that collection
    final querySnapshot = await originalCollectionRef.get();

    // 3. Build a map of timestamp -> result
    final Map<String, double> resultsMap = {};
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      // Safely read the fields
      final timestamp = data['timestamp'];
      final result = data['result'];

      // Make sure the fields exist before adding them to the map
      if (timestamp != null && result != null) {
        // Store the result under the timestamp key.
        // Converting timestamp to string so it can be used as a valid Firestore map key.
        resultsMap[timestamp.toString()] = result.toDouble();
      }
    }

    // 4. Write this map to a new document in the 'common' collection
    final statsDocRef =
        FirebaseFirestore.instance.collection('common').doc('signalstats');
    await statsDocRef.set({
      'resultsMap': resultsMap,
    }, SetOptions(merge: true));

    printDebug('Stats document created successfully!');
  }

  Future<Map<String, List<DataPoint>>> fetchResultsData() async {
    final statsDocRef =
        FirebaseFirestore.instance.collection('common').doc('signalstats');
    final snapshot = await statsDocRef.get();

    if (!snapshot.exists) {
      // If the document doesn't exist, return an empty list or handle accordingly
      return {};
    }

    final data = snapshot.data()!;
    final resultsMap = data['resultsMap'] as Map<String, dynamic>;

    List<DataPoint> dataPoints = [];

    // Convert each entry in the map to a DataPoint
    resultsMap.forEach((key, value) {
      // key is the timestamp as String, value is the result
      final int timestamp = int.parse(key); // convert string -> int
      final double result = value;

      dataPoints.add(DataPoint(timestamp: timestamp, result: result));
      printDebug('$timestamp:$result');
    });

    // Sort the list by timestamp (ascending)
    dataPoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    double cumulative = 0.0;
    List<DataPoint> cumulativeataPoints = [];
    // First, convert the map into a list of entries and sort by timestamp (key)
    final sortedEntries = resultsMap.entries.toList()
      ..sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));

    // Build the list of DataPoints cumulatively
    for (final entry in sortedEntries) {
      final timestamp = int.parse(entry.key); // convert string -> int
      final double value = entry.value; // raw value from Firestore
      cumulative += value; // add to running total

      cumulativeataPoints.add(DataPoint(
        timestamp: timestamp,
        result: cumulative,
      ));

      printDebug('$timestamp:$cumulative');
    }

    return {
      'dataPoints': dataPoints,
      'cumulativeDataPoints': cumulativeataPoints,
    };
  }
}
