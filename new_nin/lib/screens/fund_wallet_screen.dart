import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() =>
      _FundWalletScreenState();
}

class _FundWalletScreenState
    extends State<FundWalletScreen> {

  final controller = TextEditingController();

  bool loading = false;

  Future<void> fundWallet() async {

    final amount =
        double.tryParse(controller.text);

    if (amount == null || amount <= 0) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid amount"),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    await Provider.of<WalletProvider>(
      context,
      listen: false,
    ).walletService.creditWallet(amount);

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Fund Wallet"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: controller,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    loading ? null : fundWallet,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Fund Wallet"),
              ),
            )

          ],
        ),
      ),
    );
  }
}
