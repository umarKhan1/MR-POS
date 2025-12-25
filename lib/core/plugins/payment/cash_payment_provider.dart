import 'package:mrpos/core/interfaces/payment_provider.dart';
import 'package:mrpos/core/models/order.dart';

/// Built-in cash payment provider
/// No hardware required - handles manual cash transactions
class CashPaymentProvider implements PaymentProvider {
  @override
  String get id => 'cash';

  @override
  String get name => 'Cash';

  @override
  String get iconName => 'money';

  @override
  bool get requiresDevice => false;

  @override
  Future<PaymentResult> processPayment({
    required Order order,
    required double amount,
    Map<String, dynamic>? metadata,
  }) async {
    // Cash payments are always successful (manual verification)
    // In a real scenario, you might want to validate the received amount
    final received = metadata?['received'] as double? ?? amount;
    final change = received - amount;

    if (change < 0) {
      return PaymentResult.failure('Insufficient cash received');
    }

    return PaymentResult.success(
      transactionId: 'CASH-${DateTime.now().millisecondsSinceEpoch}',
      metadata: {
        'received': received,
        'change': change,
        'paymentMethod': 'Cash',
      },
    );
  }

  @override
  Future<bool> isAvailable() async {
    // Cash is always available
    return true;
  }

  @override
  Future<void> initialize() async {
    // No initialization needed for cash
  }

  @override
  Future<void> dispose() async {
    // No cleanup needed for cash
  }
}
