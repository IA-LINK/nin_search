import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/wallet_model.dart';
import '../providers/auth_provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_card.dart';
import 'fund_wallet_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    final walletProvider =
        Provider.of<WalletProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("VTU Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.authService.logout();
            },
          ),
        ],
      ),
      body: StreamBuilder<WalletModel>(
        stream: walletProvider.walletService.walletStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Wallet not found"),
            );
          }

          final wallet = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              WalletCard(
                balance: wallet.balance,
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    context,
                    Icons.account_balance_wallet,
                    "Fund",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FundWalletScreen(),
                        ),
                      );
                    },
                  ),

                  _actionButton(
                    context,
                    Icons.phone_android,
                    "Airtime",
                    () {},
                  ),

                  _actionButton(
                    context,
                    Icons.wifi,
                    "Data",
                    () {},
                  ),

                  _actionButton(
                    context,
                    Icons.receipt_long,
                    "History",
                    () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Card(
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text("No transactions yet"),
                  subtitle: Text(
                    "Your transactions will appear here",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              child: Icon(icon),
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
