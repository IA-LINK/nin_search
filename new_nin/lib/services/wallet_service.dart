import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get uid => _auth.currentUser?.uid;

  void _requireUser() {
    if (uid == null) {
      throw Exception("User not logged in");
    }
  }

  /// CREATE WALLET IF NOT EXISTS
  Future<void> createWallet() async {
    if (uid == null) return;

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

  /// REAL-TIME BALANCE STREAM (SAFE)
  Stream<double> balanceStream() {
    final userId = uid;

    if (userId == null) {
      return Stream.value(0.0);
    }

    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return 0.0;

      final data = doc.data()!;
      final balance = data['balance'];

      if (balance is int) return balance.toDouble();
      if (balance is double) return balance;

      return 0.0;
    });
  }

  /// CREDIT WALLET
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

  /// DEBIT WALLET
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

  /// SAVE TRANSACTION
  Future<void> saveTransaction({
    required String type,
    required double amount,
    required String details,
  }) async {
    _requireUser();

    final ref = _db
        .collection('users')
        .doc(uid)
        .collection('transactions');

    await ref.add({
      'type': type,
      'amount': amount,
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

Future<void> safeDebit(double amount) async {
  final userId = uid;
  if (userId == null) throw Exception("Not logged in");

  final ref = _db.collection('users').doc(userId);

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

Future<void> fundWalletAfterVerification({
  required double amount,
  required String reference,
}) async {
  await credit(amount);

  await saveTransaction(
    type: "Wallet Funding",
    amount: amount,
    details: "Reference: $reference",
  );
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


  /// TRANSACTION STREAM (SAFE + CLEAN)
  Stream<List<Map<String, dynamic>>> transactionStream() {
    final userId = uid;

    if (userId == null) {
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'id': doc.id,
        };
      }).toList();
    });
  }
}
