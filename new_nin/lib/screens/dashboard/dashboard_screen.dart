import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../services/wallet_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),

      drawer: const Sidebar(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0B),
        elevation: 0,
        title: const Text(
          "VTU Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ================= WALLET (LIVE FIRESTORE) =================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2C)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Wallet Balance",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                StreamBuilder<double>(
                  stream: WalletService().balanceStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "₦0.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text(
                        "Error loading balance",
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    final balance = snapshot.data ?? 0;

                    return Text(
                      "₦${balance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                const Text(
                  "Active Account",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Quick Services",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),

          const SizedBox(height: 10),

          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildService(Icons.phone_android, "Airtime"),
              _buildService(Icons.wifi, "Data"),
              _buildService(Icons.flash_on, "Electricity"),
              _buildService(Icons.send, "Transfer"),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Recent Transactions",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),

          const SizedBox(height: 10),

          _buildTransaction("Airtime Purchase", "-₦500"),
          _buildTransaction("Data Bundle", "-₦1,200"),
          _buildTransaction("Wallet Funding", "+₦10,000"),
        ],
      ),
    );
  }

  Widget _buildService(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white10,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildTransaction(String title, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(amount, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
