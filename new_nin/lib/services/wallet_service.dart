import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  // ================= USER CHECK =================

  void _requireUser() {
    if (uid == null) {
      throw Exception("User not logged in");
    }
  }

  // ================= WALLET =================

  Stream<double> balanceStream() {
    _requireUser();

    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();

      if (data == null) return 0.0;

      final balance = data['balance'];

      if (balance is int) {
        return balance.toDouble();
      }

      if (balance is double) {
        return balance;
      }

      return 0.0;
    });
  }

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

  Future<void> credit(double amount) async {
    _requireUser();

    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);

      if (!snap.exists) {
        throw Exception("Wallet does not exist");
      }

      final data = snap.data()!;
      final current = (data['balance'] ?? 0).toDouble();

      tx.update(ref, {
        'balance': current + amount,
      });
    });
  }

  Future<void> debit(double amount) async {
    _requireUser();

    final ref = _db.collection('users').doc(uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);

      if (!snap.exists) {
        throw Exception("Wallet does not exist");
      }

      final data = snap.data()!;
      final current = (data['balance'] ?? 0).toDouble();

      if (current < amount) {
        throw Exception("Insufficient balance");
      }

      tx.update(ref, {
        'balance': current - amount,
      });
    });
  }

  // ================= TRANSACTIONS =================

  Future<void> saveTransaction({
    required String type,
    required double amount,
    required String details,
  }) async {
    _requireUser();

    await _db.collection('transactions').add({
      'uid': uid,
      'type': type,
      'amount': amount,
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> transactionStream() {
    _requireUser();

    return _db
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
