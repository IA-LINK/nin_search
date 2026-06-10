import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> usersStream() {
    return _db.collection('users').snapshots();
  }

  Stream<QuerySnapshot> transactionsStream() {
    return _db
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateUserBalance(
    String uid,
    double newBalance,
  ) async {
    await _db.collection('users').doc(uid).update({
      'balance': newBalance,
    });
  }

  Future<void> suspendUser(String uid) async {
    await _db.collection('users').doc(uid).update({
      'status': 'suspended',
    });
  }

  Future<void> activateUser(String uid) async {
    await _db.collection('users').doc(uid).update({
      'status': 'active',
    });
  }
  Future<void> fundUserWallet(
  String uid,
  double amount,
) async {
  final userRef = _db.collection('users').doc(uid);

  await _db.runTransaction((tx) async {
    final snap = await tx.get(userRef);

    final balance =
        (snap.data()?['balance'] ?? 0).toDouble();

    tx.update(userRef, {
      'balance': balance + amount,
    });
  });
}
}
