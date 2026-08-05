import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/wallet_model.dart';

class WalletService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  Stream<WalletModel> walletStream() {

    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection('wallets')
        .doc(uid)
        .snapshots()
        .map((snapshot) {

      return WalletModel.fromMap(
        snapshot.data()!,
      );
    });
  }

  Future<void> debit(double amount) async {
  final uid = _auth.currentUser!.uid;

  final walletRef = _firestore.collection('wallets').doc(uid);

  await _firestore.runTransaction((transaction) async {
    final snapshot = await transaction.get(walletRef);

    final current = (snapshot['balance'] as num).toDouble();

    if (current < amount) {
      throw Exception("Insufficient balance");
    }

    transaction.update(walletRef, {
      'balance': current - amount,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  });
}
Future<void> saveTransaction({
  required String type,
  required double amount,
  required String status,
}) async {
  final uid = _auth.currentUser!.uid;

  await _firestore.collection('transactions').add({
    'uid': uid,
    'type': type,
    'amount': amount,
    'status': status,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

}
