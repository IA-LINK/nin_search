import 'package:flutter/material.dart';
import '../../services/payment_service.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final amountController = TextEditingController();
  bool loading = false;

  void fundWallet() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount")),
      );
      return;
    }

    setState(() => loading = true);

    await PaymentService().fundWallet(context, amount);

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

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : fundWallet,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
