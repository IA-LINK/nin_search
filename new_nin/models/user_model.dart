class UserModel {
  final String uid;
  final String email;
  final double balance;
  final String role;
  final String status;

  UserModel({
    required this.uid,
    required this.email,
    required this.balance,
    required this.role,
    required this.status,
  });

  factory UserModel.fromMap(
    String uid,
    Map<String, dynamic> data,
  ) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      balance: (data['balance'] ?? 0).toDouble(),
      role: data['role'] ?? 'user',
      status: data['status'] ?? 'active',
    );
  }
}
