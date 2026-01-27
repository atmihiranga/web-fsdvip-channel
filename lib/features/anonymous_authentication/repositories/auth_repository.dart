import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/core/failure/failure.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

// this generates a simple provider for the FirebaseAuthRepository so that it
// can be injected into the viewmodel
// https://riverpod.dev/docs/essentials/first_request#creating-the-provider
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

// this is the actual repository class
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  // above _firebaseAuth variable of FirebaseAuth type is initialized before the constructor using 'Initializer List' like below
  // https://dart.dev/language/constructors#use-an-initializer-list
  // if firebaseAuth is null, we create a FirebaseAuth.instance and set it to _firebaseAuth variable, else we set firebaseAuth to _firebaseAuth

  AuthRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Add stream for auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Either<AppFailure, UserCredential>> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential.user == null
          ? Left(AppFailure('Anonymous sign-in failed: No user returned'))
          : Right(userCredential);
    } catch (e) {
      printDebug('=====> Anonymous sign-in error: $e');
      return Left(AppFailure('Anonymous sign-in failed: ${e.toString()}'));
    }
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (e) {
      printDebug('Sign-out error: $e');
      // Consider whether you want to throw an exception here
    }
  }
}
