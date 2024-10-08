import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_anonymous_auth_repository.g.dart';

// this generates a simple provider for the FirebaseAuthRepository so that it
// can be injected into the viewmodel
@riverpod
FirebaseAuthRepository firebaseAuthRepository(FirebaseAuthRepositoryRef ref) {
  return FirebaseAuthRepository();
}

// this is the actual repository class
class FirebaseAuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<Either<AppFailure, UserCredential>> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      if (userCredential.user == null) {
        return Left(AppFailure('Error signing in anonymously'));
      }

      return Right(userCredential);
    } catch (e) {
      printDebug('Error signing in anonymously: $e');
      return Left(AppFailure(e.toString()));
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  void signOut() {
    _firebaseAuth.signOut();
  }

  // Stream<User?> authStateChanges() {
  //   return _firebaseAuth.authStateChanges();
  // }
}
