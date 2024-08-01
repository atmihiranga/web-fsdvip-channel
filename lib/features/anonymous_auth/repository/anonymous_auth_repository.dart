import 'package:firebase_auth/firebase_auth.dart';

class AnonymousAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInAnonymously() async {
    return await _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
