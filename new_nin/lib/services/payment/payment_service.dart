abstract class PaymentService {
  Future<bool> initializePayment({
    required double amount,
    required String email,
  });

  Future<bool> verifyPayment(String reference);
}
