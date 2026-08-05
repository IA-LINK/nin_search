import '../services/wallet_service.dart';

class VtuEngine {
  final WalletService wallet;

  VtuEngine(this.wallet);

  Future<void> processAirtime({
    required String phone,
    required String network,
    required double amount,
  }) async {
    await wallet.debit(amount);

    await wallet.saveTransaction(
      type: "Airtime Purchase",
      amount: amount,
      details: "$network Airtime sent to $phone",
    );
  }

  Future<void> processData({
    required String phone,
    required String network,
    required String plan,
    required double amount,
  }) async {
    await wallet.debit(amount);

    await wallet.saveTransaction(
      type: "Data Purchase",
      amount: amount,
      details: "$network $plan sent to $phone",
    );
  }

  Future<void> fundWallet({
    required double amount,
    required String reference,
  }) async {
    await wallet.credit(amount);

    await wallet.saveTransaction(
      type: "Wallet Funding",
      amount: amount,
      details: "Ref: $reference",
    );
  }
}
