import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_3_forex_signals_daily/debug/print_debug.dart';
import 'package:project_3_forex_signals_daily/features/anonymous_authentication/repositories/auth_repository.dart';
import 'package:project_3_forex_signals_daily/features/in_app_purchases/view_models/in_app_purchase_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  // we put 'late' keyword because we're initializing _firebaseAuthRepository later, in build method
  late final AuthRepository _authRepository;

  @override
  AsyncValue<User?> build() {
    // this is where we initialize _firebaseAuthRepository. Instead of directly initializing with a firebaseAuthRepository class
    // as "_firebaseAuthRepository = FirebaseAuthRepository();" we do it with a provider, because we can watch changes in the repository
    // when we do it with the provider, this is called dependency injection
    _authRepository = ref.watch(authRepositoryProvider);

    // Listen to auth state changes
    ref.listen(authRepositoryProvider.select((repo) => repo.authStateChanges),
        (previous, next) {
      next.listen((user) {
        state = AsyncValue.data(user);
      });
    });

    // we call getCurrentUser() to get the current user. if currentUser is null, it means user is not signed in. then we call _checkAndSignIn
    // and AsyncValue.loading() state. if user is not null, that means user is already signed, then we return currentUser as AsyncValue
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser != null) {
      printDebug('=====> auth vm > got current user ${currentUser.uid}');

      return AsyncValue.data(currentUser);
    }
    _checkAndSignInAnonymously();
    return const AsyncValue.loading();
  }

  Future<void> _checkAndSignInAnonymously() async {
    state = const AsyncValue.loading();

    final signInResult = await _authRepository.signInAnonymously();

    state = signInResult.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (credential) => AsyncValue.data(credential.user),
    );
  }

  Future<void> linkWithGoogle() async {
    state = const AsyncValue.loading();

    final linkResult = await _authRepository.linkAnonymousWithGoogle();

    state = linkResult.fold(
      (failure) {
        printDebug(
            '=====> auth vm > link with google failed, trying to get current user');
        final currentUser = _authRepository.getCurrentUser();

        if (currentUser != null) {
          printDebug(
              '=====> auth vm > current user present, returning current user');
          return AsyncValue.data(currentUser);
        }
        printDebug(
            '=====> auth vm > current user not exist, signing in anonymously');
        _checkAndSignInAnonymously();
        return const AsyncValue.loading();
      },
      (credential) {
        ref.read(inAppPurchaseViewModelProvider.notifier).restorePurchases();
        return AsyncValue.data(credential.user);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    final signInResult = await _authRepository.signInWithGoogle();

    state = signInResult.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (credential) => AsyncValue.data(credential.user),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await _authRepository.signOut();
    // when user signs out, we sign them in again anonymously
    await _checkAndSignInAnonymously();
  }

  User? getCurrentUser() => _authRepository.getCurrentUser();
}
