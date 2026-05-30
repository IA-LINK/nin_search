import 'package:flutter/material.dart';
import '../../widgets/dashboard/wallet_card.dart';
import '../../widgets/dashboard/bonus_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // TOP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3B2E),
        elevation: 0,
        leading: const Icon(Icons.menu),
        title: const Text(""),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "NewWay",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text("Home / Dashboard"),
              const SizedBox(height: 20),

              // WALLET CARD
              const WalletCard(balance: "₦930.00"),

              const SizedBox(height: 20),

              // BONUS CARD
              const BonusCard(balance: "₦0.00"),
            ],
          ),
        ),
      ),
    );
  }
}
