import 'package:flutter/material.dart';

class FundWalletScreen extends StatelessWidget {
  const FundWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Wallet'),
      ),
      body: const Center(
        child: Text('Fund Wallet Screen'),
      ),
    );
  }
}
