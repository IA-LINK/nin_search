import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Login error: ${e.message}");
      return null;
    } catch (e) {
      print("Unknown login error: $e");
      return null;
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Register error: ${e.message}");
      return null;
    } catch (e) {
      print("Unknown register error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> logout() async {
    await signOut();
  }
}
