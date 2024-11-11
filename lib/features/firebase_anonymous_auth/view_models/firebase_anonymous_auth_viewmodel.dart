import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/firebase_anonymous_auth/repositories/firebase_anonymous_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'firebase_anonymous_auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  // we put 'late' keyword because we're initializing _firebaseAuthRepository later, in build method
  late final FirebaseAuthRepository _firebaseAuthRepository;

  @override
  AsyncValue<User?> build() {
    // this is where we initialize _firebaseAuthRepository. Instead of directly initializing with a firebaseAuthRepository class
    // as "_firebaseAuthRepository = FirebaseAuthRepository();" we do it with a provider, because we can watch changes in the repository
    // when we do it with the provider, this is called dependency injection
    _firebaseAuthRepository = ref.watch(firebaseAuthRepositoryProvider);

    // we call getCurrentUser() to get the current user. if currentUser is null, it means user is not signed in. then we call _checkAndSignIn
    // and AsyncValue.loading() state. if user is not null, that means user is already signed, then we return currentUser as AsyncValue
    final currentUser = _firebaseAuthRepository.getCurrentUser();
    if (currentUser != null) {
      return AsyncValue.data(currentUser);
    } else {
      _checkAndSignIn();
      return const AsyncValue.loading();
    }
  }

  Future<void> _checkAndSignIn() async {
    printDebug(
        '=====> firebase_anonymous_auth_vewmodel: called _checkAndSignIn');
    state = const AsyncValue.loading();

    // below signInResult can be either Left(AppFailure) or Right(UserCredential)
    final signInResult = await _firebaseAuthRepository.signInAnonymously();
    printDebug('=====> signInResult: $signInResult');

    // below we use dart pattern matching to set state based on left and right
    // tutorial : https://youtu.be/CWvlOU2Y3Ik?t=10012
    final val = switch (signInResult) {
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
}
