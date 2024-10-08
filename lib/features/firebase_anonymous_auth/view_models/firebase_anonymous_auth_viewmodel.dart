import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/firebase_anonymous_auth/repository/firebase_anonymous_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firebase_anonymous_auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final FirebaseAuthRepository _firebaseAuthRepository;

  @override
  AsyncValue<User?> build() {
    _firebaseAuthRepository = ref.watch(firebaseAuthRepositoryProvider);
    final currentUser = _firebaseAuthRepository.getCurrentUser();
    if (currentUser != null) {
      return AsyncValue.data(currentUser);
    } else {
      _checkAndSignIn();
      return const AsyncValue.loading();
    }
  }

  Future<void> _checkAndSignIn() async {
    printDebug('=====> Checking and signing in');
    state = const AsyncValue.loading();
    final userCredential = await _firebaseAuthRepository.signInAnonymously();
    printDebug('=====> UserCredential: $userCredential');
    final val = switch (userCredential) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r.user),
    };
    printDebug('=====> Val: $val');
  }

  void signOut() {
    state = const AsyncValue.loading();
    _firebaseAuthRepository.signOut();
    _checkAndSignIn();
  }

  // Stream<User?> authStateChanges() {
  //   return _repository.authStateChanges();
  // }
}

// @riverpod
// FirebaseAuthRepository firebaseAuthRepository(FirebaseAuthRepositoryRef ref) {
//   return FirebaseAuthRepository();
// }
