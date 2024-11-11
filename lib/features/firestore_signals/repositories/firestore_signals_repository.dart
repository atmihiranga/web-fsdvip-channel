import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_signals_repository.g.dart';

@riverpod
FirestoreSignalsRepository firestoreSignalsRepository(Ref ref) {
  return FirestoreSignalsRepository();
}

class FirestoreSignalsRepository {
  final FirebaseFirestore _firebaseFirestore;

  // List<SignalModel> validSignalsList = [];

  FirestoreSignalsRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  // Future<Either<AppFailure, List<SignalModel>>>
  //     // this will
  //     fetchSignalsFromFirestore() async {
  //   try {
  //     final QuerySnapshot<Map<String, dynamic>> snapshot =
  //         await _firebaseFirestore
  //             .collection('signaldb')
  //             .orderBy('timestamp', descending: true)
  //             .limit(10)
  //             .get();

  //     final signalList = snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       data['id'] = doc.id;
  //       try {
  //         final signal = SignalModel.fromMap(data);
  //         return signal;
  //       } catch (e) {
  //         printDebug(
  //             'Error converting document to SignalModel: $e'); // Debug printDebug
  //         return null; // Return null
  //       }
  //     }).toList();

  //     // Filter out any null values (failed conversions)
  //     final validSignals = signalList.whereType<SignalModel>().toList();

  //     if (validSignals.isEmpty) {
  //       return Left(
  //           AppFailure('No valid signals found after conversion errors.'));
  //     }
  //     validSignalsList = validSignals;
  //     return Right(validSignals);
  //   } catch (e) {
  //     printDebug('Error in getSignalsFromFirestore: $e'); // Debug printDebug
  //     return Left(AppFailure(e.toString()));
  //   }
  // }

  // List<SignalModel> getSignalList() {
  //   return validSignalsList;
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> signalStream() {
    return _firebaseFirestore
        .collection('signaldb')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }
}
