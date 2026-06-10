import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/wallet_service.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  String network = "MTN";
  String plan = "1GB";

  final phoneController = TextEditingController();
  bool loading = false;

  final Map<String, double> prices = {
    "1GB": 500,
    "2GB": 1000,
    "5GB": 2500,
  };

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> buyData() async {
    final phone = phoneController.text.trim();
    final amount = prices[plan]!;

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final wallet = context.read<WalletService>();

      await wallet.debit(amount);

      await wallet.saveTransaction(
        type: "Data Purchase",
        amount: amount,
        details: "$network $plan to $phone",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Purchase Successful")),
      );

      phoneController.clear();
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
        title: const Text("Buy Data"),
        backgroundColor: const Color(0xFF0B0B0B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // NETWORK SELECT
            DropdownButtonFormField(
              value: network,
              dropdownColor: Colors.black,
              items: ["MTN", "Airtel", "Glo", "9mobile"]
                  .map((net) => DropdownMenuItem(
                        value: net,
                        child: Text(net, style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => network = value.toString());
              },
              decoration: const InputDecoration(
                labelText: "Network",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            // PHONE INPUT
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone Number",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            // PLAN SELECT
            DropdownButtonFormField(
              value: plan,
              dropdownColor: Colors.black,
              items: prices.keys
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          "$p - ₦${prices[p]}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => plan = value.toString());
              },
              decoration: const InputDecoration(
                labelText: "Data Plan",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : buyData,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Buy Data"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
