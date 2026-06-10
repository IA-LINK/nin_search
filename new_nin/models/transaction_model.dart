class TransactionModel {
  final String id;
  final String type;
  final double amount;
  final String details;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.details,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'details': details,
      'createdAt': createdAt,
    };
  }

  static TransactionModel fromMap(String id, Map<String, dynamic> data) {
    return TransactionModel(
      id: id,
      type: data['type'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      details: data['details'] ?? '',
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
    );
  }
}
