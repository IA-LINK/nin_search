class WalletModel {
  final String uid;
  final double balance;
  final String currency;

  WalletModel({
    required this.uid,
    required this.balance,
    required this.currency,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      uid: map['uid'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'NGN',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'balance': balance,
      'currency': currency,
    };
  }
}
