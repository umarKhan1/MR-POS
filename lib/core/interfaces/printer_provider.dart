import 'package:mrpos/core/models/order.dart';

/// Abstract interface for printer providers
/// Implement this to add custom printer integrations
abstract class PrinterProvider {
  /// Unique identifier for this printer provider
  String get id;

  /// Display name shown to users
  String get name;

  /// Icon name for the printer type
  String get iconName;

  /// Whether this provider requires a physical printer
  bool get requiresDevice;

  /// Print a receipt
  /// Returns true if printing was successful, false otherwise
  Future<PrintResult> printReceipt({
    required Order order,
    required String paymentMethod,
    required double tip,
    required double received,
    required double change,
  });

  /// Check if the printer is available/connected
  Future<bool> isAvailable();

  /// Initialize the printer provider (connect to device, etc.)
  Future<void> initialize();

  /// Cleanup resources
  Future<void> dispose();
}

/// Result of a print operation
class PrintResult {
  final bool success;
  final String? errorMessage;
  final String? filePath; // For PDF/file-based printers
  final Map<String, dynamic>? metadata;

  const PrintResult({
    required this.success,
    this.errorMessage,
    this.filePath,
    this.metadata,
  });

  factory PrintResult.success({
    String? filePath,
    Map<String, dynamic>? metadata,
  }) {
    return PrintResult(success: true, filePath: filePath, metadata: metadata);
  }

  factory PrintResult.failure(String errorMessage) {
    return PrintResult(success: false, errorMessage: errorMessage);
  }
}
