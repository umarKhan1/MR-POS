import 'package:mrpos/core/interfaces/payment_provider.dart';
import 'package:mrpos/core/models/order.dart';

/// Built-in card payment provider (simulated)
/// For real card payments, replace with actual payment device integration
class CardPaymentProvider implements PaymentProvider {
  @override
  String get id => 'card';

  @override
  String get name => 'Debit Card';

  @override
  String get iconName => 'credit_card';

  @override
  bool get requiresDevice => true;

  @override
  Future<PaymentResult> processPayment({
    required Order order,
    required double amount,
    Map<String, dynamic>? metadata,
  }) async {
    // Simulate card payment processing
    // In production, this would communicate with actual payment terminal

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate 95% success rate
    final random = DateTime.now().millisecond;
    if (random % 20 == 0) {
      return PaymentResult.failure('Card declined');
    }

    return PaymentResult.success(
      transactionId: 'CARD-${DateTime.now().millisecondsSinceEpoch}',
      metadata: {
        'cardType': 'Visa', // Would come from actual device
        'last4': '****', // Would come from actual device
        'paymentMethod': 'Debit Card',
      },
    );
  }

  @override
  Future<bool> isAvailable() async {
    // In production, check if payment terminal is connected
    // For now, always return true (simulated)
    return true;
  }

  @override
  Future<void> initialize() async {
    // In production, initialize connection to payment terminal
    // For now, do nothing (simulated)
  }

  @override
  Future<void> dispose() async {
    // In production, disconnect from payment terminal
    // For now, do nothing (simulated)
  }
}
