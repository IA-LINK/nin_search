import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/wallet_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletService = context.watch<WalletService>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: const Color(0xFF0B0B0B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: walletService.transactionStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Unable to load transactions",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final transactions = snapshot.data ?? [];

            if (transactions.isEmpty) {
              return const Center(
                child: Text(
                  "No Transactions Yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];

                final timestamp = tx['createdAt'];

                String timeText = "Just now";

                if (timestamp != null && timestamp is DateTime) {
                  timeText = timestamp.toString();
                }

                return Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.green,
                    ),
                    title: Text(
                      tx['type'] ?? 'Transaction',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx['details'] ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeText,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "₦${tx['amount'] ?? 0}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
