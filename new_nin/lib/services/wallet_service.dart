import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  /// 🔥 REAL-TIME BALANCE STREAM
  Stream<double> balanceStream() {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      return (doc.data()?['balance'] ?? 0).toDouble();
    });
  }

  /// 🔥 CREATE WALLET IF NOT EXISTS
  Future<void> createWallet() async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      await _db.collection('users').doc(uid).set({
        'balance': 0,
        'email': _auth.currentUser!.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🔥 CREDIT WALLET
  Future<void> credit(double amount) async {
    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap['balance'] ?? 0).toDouble();

      tx.update(ref, {
        'balance': current + amount,
      });
    });
  }

  /// 🔥 DEBIT WALLET
  Future<void> debit(double amount) async {
    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = (snap['balance'] ?? 0).toDouble();

      if (current < amount) {
        throw Exception("Insufficient balance");
      }

      tx.update(ref, {
        'balance': current - amount,
      });
    });
  }
}
