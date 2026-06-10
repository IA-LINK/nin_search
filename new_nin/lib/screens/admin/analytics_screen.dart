import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('transactions')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          double totalRevenue = 0;

          for (final doc in docs) {
            totalRevenue +=
                (doc['amount'] ?? 0).toDouble();
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: ListTile(
                  title: const Text(
                    "Total Transaction Volume",
                  ),
                  subtitle: Text(
                    "₦${totalRevenue.toStringAsFixed(2)}",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
