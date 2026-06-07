import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔵 CREATE USER WALLET IF NOT EXISTS
  Future<void> createWalletIfNotExists() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      await _db.collection('users').doc(uid).set({
        'balance': 0,
        'email': _auth.currentUser!.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // 🔵 GET BALANCE STREAM (REAL TIME)
  Stream<double> getBalanceStream() {
    final uid = _auth.currentUser!.uid;

    return _db.collection('users').doc(uid).snapshots().map((doc) {
      return (doc['balance'] ?? 0).toDouble();
    });
  }

  // 🔵 ADD MONEY
  Future<void> creditWallet(double amount) async {
    final uid = _auth.currentUser!.uid;

    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);

      double current = (snapshot['balance'] ?? 0).toDouble();

      transaction.update(ref, {
        'balance': current + amount,
      });
    });
  }

  // 🔵 DEDUCT MONEY
  Future<void> debitWallet(double amount) async {
    final uid = _auth.currentUser!.uid;

    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);

      double current = (snapshot['balance'] ?? 0).toDouble();

      if (current < amount) {
        throw Exception("Insufficient balance");
      }

      transaction.update(ref, {
        'balance': current - amount,
      });
    });
  }
}
