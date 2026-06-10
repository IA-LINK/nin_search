import '../wallet_service.dart';

class VtuService {
  final WalletService wallet;

  VtuService(this.wallet);

  Future<void> buyAirtime({
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

  Future<void> buyData({
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
}
