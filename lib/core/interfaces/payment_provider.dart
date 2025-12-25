import 'package:mrpos/core/models/order.dart';

/// Abstract interface for payment providers
/// Implement this to add custom payment device integrations
abstract class PaymentProvider {
  /// Unique identifier for this payment provider
  String get id;

  /// Display name shown to users
  String get name;

  /// Icon name for the payment method
  String get iconName;

  /// Whether this provider requires a physical device
  bool get requiresDevice;

  /// Process a payment
  /// Returns true if payment was successful, false otherwise
  Future<PaymentResult> processPayment({
    required Order order,
    required double amount,
    Map<String, dynamic>? metadata,
  });

  /// Check if the payment device is available/connected
  Future<bool> isAvailable();

  /// Initialize the payment provider (connect to device, etc.)
  Future<void> initialize();

  /// Cleanup resources
  Future<void> dispose();
}

/// Result of a payment transaction
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    this.metadata,
  });

  factory PaymentResult.success({
    String? transactionId,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      metadata: metadata,
    );
  }

  factory PaymentResult.failure(String errorMessage) {
    return PaymentResult(success: false, errorMessage: errorMessage);
  }
}
