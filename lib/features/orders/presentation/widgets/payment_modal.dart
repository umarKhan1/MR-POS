import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/core/interfaces/payment_provider.dart';
import 'package:mrpos/core/plugins/payment/cash_payment_provider.dart';
import 'package:mrpos/core/plugins/payment/card_payment_provider.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/features/orders/presentation/widgets/receipt_widget.dart';

class PaymentModal extends StatefulWidget {
  final Order order;

  const PaymentModal({super.key, required this.order});

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  String _selectedPaymentMethod = 'cash';
  final _receivedController = TextEditingController();
  final _tipController = TextEditingController(text: '0');

  // Payment providers
  late final CashPaymentProvider _cashProvider;
  late final CardPaymentProvider _cardProvider;

  @override
  void initState() {
    super.initState();
    _receivedController.text = widget.order.total.toStringAsFixed(2);

    // Initialize payment providers
    _cashProvider = CashPaymentProvider();
    _cardProvider = CardPaymentProvider();
    _cashProvider.initialize();
    _cardProvider.initialize();

    // Listen to tip changes and update received amount
    _tipController.addListener(() {
      if (_selectedPaymentMethod == 'cash') {
        final newTotal = _totalWithTip;
        _receivedController.text = newTotal.toStringAsFixed(2);
      }
    });
  }

  @override
  void dispose() {
    _receivedController.dispose();
    _tipController.dispose();
    _cashProvider.dispose();
    _cardProvider.dispose();
    super.dispose();
  }

  double get _tip => double.tryParse(_tipController.text) ?? 0.0;
  double get _totalWithTip => widget.order.total + _tip;
  double get _received => double.tryParse(_receivedController.text) ?? 0.0;
  double get _change => _received - _totalWithTip;

  void _completeOrder() async {
    PaymentProvider provider;
    Map<String, dynamic> metadata = {};

    // Select provider based on payment method
    if (_selectedPaymentMethod == 'cash') {
      provider = _cashProvider;
      metadata = {'received': _received, 'change': _change};

      // Validate cash payment
      if (_change < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Received amount is less than total!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      provider = _cardProvider;
      // Show card payment dialog
      final shouldProceed = await _showCardPaymentDialog();
      if (!shouldProceed) return;
    }

    // Process payment through provider
    final result = await provider.processPayment(
      order: widget.order,
      amount: _totalWithTip,
      metadata: metadata,
    );

    if (!result.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Payment failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Mark order as completed
    if (mounted) {
      context.read<OrdersCubit>().updateOrderStatus(
        widget.order.id,
        OrderStatus.confirmed,
        'Confirmed',
      );

      // Close payment modal
      Navigator.of(context).pop();

      // Show receipt
      showDialog(
        context: context,
        builder: (context) => ReceiptWidget(
          order: widget.order,
          paymentMethod: _selectedPaymentMethod == 'cash'
              ? 'Cash'
              : 'Debit Card',
          tip: _tip,
          received: _selectedPaymentMethod == 'cash'
              ? _received
              : _totalWithTip,
          change: _selectedPaymentMethod == 'cash' ? _change : 0,
          transactionId: result.transactionId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Dialog(
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.orderNumber,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      widget.order.customerName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            24.h,
            // Items list
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.order.items.length,
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '0${index + 1}',
                              style: const TextStyle(
                                color: AppColors.primaryRed,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        12.w,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'x ${item.quantity}',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[500]
                                      : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            24.h,
            // Summary
            _buildSummaryRow(context, 'Subtotal', widget.order.subtotal),
            8.h,
            _buildSummaryRow(context, 'Tax 5%', widget.order.tax),
            8.h,
            // Tip input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tip',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _tipController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      prefix: Text(
                        '\$',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            16.h,
            Divider(color: Colors.grey[700]),
            12.h,
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '\$${_totalWithTip.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            24.h,
            // Received amount (for cash)
            if (_selectedPaymentMethod == 'cash') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Received',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _receivedController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        prefix: Text(
                          '\$',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              16.h,
            ],
            // Payment methods
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            16.h,
            Row(
              children: [
                Expanded(
                  child: _buildPaymentMethodButton('Cash', Icons.money, 'cash'),
                ),
                16.w,
                Expanded(
                  child: _buildPaymentMethodButton(
                    'Debit Card',
                    Icons.credit_card,
                    'card',
                  ),
                ),
              ],
            ),
            24.h,
            // Order Completed button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Order Completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double amount) {
    final isDark = context.isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodButton(String label, IconData icon, String value) {
    final isDark = context.isDarkMode;
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withValues(alpha: 0.2)
              : (isDark ? const Color(0xFF1A1A1A) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryRed
                : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryRed
                  : (isDark ? Colors.grey[600] : Colors.grey[400]),
              size: 32,
            ),
            8.h,
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primaryRed
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showCardPaymentDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CardPaymentDialog(),
        ) ??
        false;
  }
}

class CardPaymentDialog extends StatefulWidget {
  const CardPaymentDialog({super.key});

  @override
  State<CardPaymentDialog> createState() => _CardPaymentDialogState();
}

class _CardPaymentDialogState extends State<CardPaymentDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _processing = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Dialog(
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_processing && !_success) ...[
              const Icon(
                Icons.contactless,
                size: 80,
                color: AppColors.primaryRed,
              ),
              24.h,
              Text(
                'Tap Your Card',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              16.h,
              Text(
                'Hold your card near the reader',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              32.h,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simulateCardTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simulate Card Tap',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              8.h,
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ] else if (_processing) ...[
              RotationTransition(
                turns: _controller,
                child: const Icon(
                  Icons.sync,
                  size: 80,
                  color: AppColors.primaryRed,
                ),
              ),
              24.h,
              const Text(
                'Processing Payment...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ] else if (_success) ...[
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              24.h,
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _simulateCardTap() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _processing = false;
      _success = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }
}
