import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletCard extends StatelessWidget {
  final double balance;
  final bool loading;
  final VoidCallback? onFund;

  const WalletCard({
    super.key,
    required this.balance,
    this.loading = false,
    this.onFund,
  });

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: "₦",
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Wallet Balance",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  formatCurrency(balance),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onFund,
              child: const Text("Fund Wallet"),
            ),
          ),
        ],
      ),
    );
  }
}
