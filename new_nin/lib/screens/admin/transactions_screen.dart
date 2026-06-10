import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final txs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: txs.length,
            itemBuilder: (_, index) {
              final tx = txs[index];

              return ListTile(
                title: Text(tx['type']),
                subtitle: Text(tx['details']),
                trailing: Text(
                  "₦${tx['amount']}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
