import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  FirebaseAuth get _firebaseAuth {
    if (Firebase.apps.isEmpty) {
      throw StateError(
        'Firebase is not initialized. Call Firebase.initializeApp or configure Firebase in main.dart',
      );
    }

    return FirebaseAuth.instance;
  }

  Future<User?> login(String email, String password) async {
    final firebaseAuth = _firebaseAuth;

    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      return null;
    } on StateError {
      rethrow;
    }
  }

  Future<User?> register(String email, String password) async {
    final firebaseAuth = _firebaseAuth;

    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      return null;
    } on StateError {
      rethrow;
    }
  }

  Future<void> signOut() {
    final firebaseAuth = _firebaseAuth;
    return firebaseAuth.signOut();
  }

  Future<void> logout() {
    return signOut();
  }
}
