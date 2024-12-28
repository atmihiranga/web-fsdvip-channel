import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

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

  Future<Either<AppFailure, UserCredential>> linkAnonymousWithGoogle() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return Left(AppFailure('No anonymous user to link'));
      }

      if (!currentUser.isAnonymous) {
        return Left(AppFailure('Current user is not anonymous'));
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Left(AppFailure('Google sign-in cancelled by user'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await currentUser.linkWithCredential(credential);

      // Add this section to update user profile
      await userCredential.user?.updateDisplayName(googleUser.displayName);
      await userCredential.user?.updatePhotoURL(googleUser.photoUrl);

      // Force refresh to ensure we have the latest user data
      await userCredential.user?.reload();
      printDebug(
          '=====> Google sign-in credential : ${userCredential.user.toString()}');
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        try {
          final credential = e.credential;
          if (credential != null) {
            // Sign in with the existing account
            printDebug(
                '=====> auth repo > linking > already linked, signing with existing account');
            final userCredential =
                await _firebaseAuth.signInWithCredential(credential);
            return Right(userCredential);
          }
        } catch (signInError) {
          return Left(AppFailure(
              'Error signing in with existing account: $signInError'));
        }
      }
      printDebug('=====> Link with Google error: $e');
      return Left(AppFailure('Failed to link with Google: ${e.toString()}'));
    } catch (e) {
      printDebug('=====> Link with Google error: $e');
      return Left(AppFailure('Failed to link with Google: ${e.toString()}'));
    }
  }

  // we do not use below method to directly sign in with google, instead we use linkAnonymousWithGoogle method
  // because it will link google account with anonymous auth, so it can keep same user.uid
  Future<Either<AppFailure, UserCredential>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Left(AppFailure('Google sign-in cancelled by user'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      printDebug(
          '=====> Google sign-in credential : ${userCredential.user.toString()}');

      return userCredential.user == null
          ? Left(AppFailure('Google sign-in failed: No user returned'))
          : Right(userCredential);
    } catch (e) {
      printDebug('=====> Google sign-in error: $e');
      return Left(AppFailure('Google sign-in failed: ${e.toString()}'));
    }
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      printDebug('Sign-out error: $e');
      // Consider whether you want to throw an exception here
    }
  }
}
