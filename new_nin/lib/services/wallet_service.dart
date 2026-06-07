import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  /// 🔥 CHECK USER SAFETY
  void _requireUser() {
    if (uid == null) {
      throw Exception("User not logged in");
    }
  }

  /// 🔥 REAL-TIME BALANCE STREAM
  Stream<double> balanceStream() {
    _requireUser();

    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();

      if (data == null) return 0.0;

      return (data['balance'] ?? 0).toDouble();
    });
  }

  /// 🔥 CREATE WALLET IF NOT EXISTS
  Future<void> createWallet() async {
    _requireUser();

    final ref = _db.collection('users').doc(uid);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'balance': 0.0,
        'email': _auth.currentUser?.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🔥 CREDIT WALLET
  Future<void> credit(double amount) async {
    _requireUser();

    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);

      final data = snap.data();
      final current = (data?['balance'] ?? 0).toDouble();

      tx.update(ref, {
        'balance': current + amount,
      });
    });
  }

  /// 🔥 DEBIT WALLET
  Future<void> debit(double amount) async {
    _requireUser();

    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);

      final data = snap.data();
      final current = (data?['balance'] ?? 0).toDouble();

      if (current < amount) {
        throw Exception("Insufficient balance");
      }

      tx.update(ref, {
        'balance': current - amount,
      });
    });
  }
}
