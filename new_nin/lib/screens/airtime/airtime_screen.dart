import 'package:flutter/material.dart';
import '../../services/wallet_service.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  String network = "MTN";
  bool loading = false;

  void buyAirtime() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // 💰 Deduct from wallet
      await WalletService().debit(amount);

      // 📌 Save transaction (simple version for now)
      await WalletService().saveTransaction(
        type: "Airtime",
        amount: amount,
        details: "$network - ${phoneController.text}",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Airtime Purchase Successful")),
      );

      phoneController.clear();
      amountController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text("Buy Airtime"),
        backgroundColor: const Color(0xFF0B0B0B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // NETWORK SELECT
            DropdownButtonFormField(
              value: network,
              dropdownColor: Colors.black,
              items: const [
                DropdownMenuItem(value: "MTN", child: Text("MTN")),
                DropdownMenuItem(value: "Airtel", child: Text("Airtel")),
                DropdownMenuItem(value: "Glo", child: Text("Glo")),
                DropdownMenuItem(value: "9mobile", child: Text("9mobile")),
              ],
              onChanged: (value) {
                setState(() => network = value.toString());
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Network",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone Number",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : buyAirtime,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Buy Airtime"),
            ),
          ],
        ),
      ),
    );
  }
}
