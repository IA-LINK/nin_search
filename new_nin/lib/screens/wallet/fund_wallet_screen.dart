import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/wallet_service.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final amountController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> fundWallet() async {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final wallet = context.read<WalletService>();

      await wallet.credit(amount);

      await wallet.saveTransaction(
        type: "Wallet Funding",
        amount: amount,
        details: "Wallet funded successfully",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wallet Funded Successfully")),
      );

      amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text("Fund Wallet"),
        backgroundColor: const Color(0xFF0B0B0B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : fundWallet,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Fund Wallet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
