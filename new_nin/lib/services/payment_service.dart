import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'wallet_service.dart';

class PaymentService {
  final PaystackPlugin _paystack = PaystackPlugin();

  PaymentService() {
    _paystack.initialize(
      publicKey: "pk_test_xxxxxxxxxxxxx",
    );
  }

  Future<void> fundWallet(BuildContext context, double amount) async {
    Charge charge = Charge()
      ..amount = (amount * 100).toInt()
      ..email = "user@example.com"
      ..reference = DateTime.now().millisecondsSinceEpoch.toString();

    CheckoutResponse response = await _paystack.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      await WalletService().credit(amount);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wallet Funded Successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    }
  }
}
