import 'package:flutter/material.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/core/plugins/printer/pdf_printer_provider.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class ReceiptWidget extends StatelessWidget {
  final Order order;
  final String paymentMethod;
  final double tip;
  final double received;
  final double change;
  final String? transactionId;

  const ReceiptWidget({
    super.key,
    required this.order,
    required this.paymentMethod,
    required this.tip,
    required this.received,
    required this.change,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Dialog(
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Receipt content - scrollable
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // POS Name
                      Text(
                        'MR POS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 2,
                        ),
                      ),
                      8.h,
                      Text(
                        'Restaurant Management System',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      4.h,
                      Text(
                        'Tel: +1 (555) 123-4567',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      _buildDivider(context),
                      16.h,
                      // Receipt title
                      Text(
                        'CASH RECEIPT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 1,
                        ),
                      ),
                      16.h,
                      _buildDivider(context),
                      16.h,
                      // Order details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order: ${order.orderNumber}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            _formatDate(order.orderDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      4.h,
                      Row(
                        children: [
                          Text(
                            'Customer: ${order.customerName}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      16.h,
                      _buildDivider(context),
                      16.h,
                      // Items header
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              'Price',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      8.h,
                      // Items
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'x${item.quantity} @ \$${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      16.h,
                      _buildDivider(context),
                      16.h,
                      // Totals
                      _buildReceiptRow(context, 'Subtotal', order.subtotal),
                      4.h,
                      _buildReceiptRow(context, 'Tax', order.tax),
                      4.h,
                      _buildReceiptRow(context, 'Charges', order.charges),
                      if (tip > 0) ...[
                        4.h,
                        _buildReceiptRow(context, 'Tip', tip),
                      ],
                      12.h,
                      _buildDivider(context),
                      12.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            '\$${(order.total + tip).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      16.h,
                      _buildDivider(context),
                      16.h,
                      // Payment details
                      _buildReceiptRow(
                        context,
                        'Payment Method',
                        0,
                        value: paymentMethod,
                      ),
                      if (paymentMethod == 'Cash') ...[
                        4.h,
                        _buildReceiptRow(context, 'Cash', received),
                        4.h,
                        _buildReceiptRow(context, 'Change', change),
                      ],
                      16.h,
                      _buildDivider(context),
                      16.h,
                      // Thank you
                      Text(
                        'THANK YOU!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 2,
                        ),
                      ),
                      16.h,
                      // Barcode placeholder
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            order.orderNumber,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Courier',
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Action buttons - fixed at bottom
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.05,
                    ),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Close'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? Colors.white
                            : Colors.grey[700],
                        side: BorderSide(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  16.w,
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryRed,
                            AppColors.primaryRed.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRed.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Use PDF printer provider
                          final pdfPrinter = PdfPrinterProvider();
                          await pdfPrinter.initialize();

                          final result = await pdfPrinter.printReceipt(
                            order: order,
                            paymentMethod: paymentMethod,
                            tip: tip,
                            received: received,
                            change: change,
                          );

                          if (result.success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Receipt saved: ${result.filePath ?? "receipt.pdf"}',
                                ),
                                backgroundColor: Colors.green,
                                action: SnackBarAction(
                                  label: 'OK',
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            );
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.errorMessage ??
                                      'Failed to generate PDF',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          await pdfPrinter.dispose();
                        },
                        icon: const Icon(Icons.download_rounded, size: 20),
                        label: const Text(
                          'Download Receipt',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = context.isDarkMode;
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: 1,
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    BuildContext context,
    String label,
    double amount, {
    String? value,
  }) {
    final isDark = context.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        Text(
          value ?? '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
