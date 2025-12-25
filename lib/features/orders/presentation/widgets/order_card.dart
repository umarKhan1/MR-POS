// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:mrpos/core/models/order.dart';
import 'package:mrpos/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:mrpos/features/orders/presentation/widgets/payment_modal.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final int orderIndex;

  const OrderCard({super.key, required this.order, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: order.status == OrderStatus.inProcess
            ? Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.5),
                width: 2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    orderIndex.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              10.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Order ${order.orderNumber}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                        6.w,
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: _getStatusColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          8.h,
          // Status detail dropdown
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showStatusDetailDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.statusDetail,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                    4.w,
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          8.h,
          // Items table
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table header
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        'Qty',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Items',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Price',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                4.h,
                // Items
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text(
                            item.quantity.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.h,
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SubTotal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${order.subtotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          10.h,
          // Action buttons - only show for active orders (not completed or cancelled)
          if (order.status != OrderStatus.completed &&
              order.status != OrderStatus.cancelled) ...[
            Row(
              children: [
                _buildActionButton(
                  icon: FontAwesomeIcons.penToSquare,
                  onPressed: () {
                    GoRouter.of(
                      context,
                    ).push('/create-order?orderId=${order.id}');
                  },
                ),
                8.w,
                _buildActionButton(
                  icon: FontAwesomeIcons.trash,
                  onPressed: () => _cancelOrder(context),
                ),
                const Spacer(),
                Expanded(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => PaymentModal(order: order),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Pay Bill',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(), color: _getStatusColor(), size: 11),
          5.w,
          Text(
            order.status.displayName,
            style: TextStyle(
              color: _getStatusColor(),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.ready:
        return const Color(0xFF4CAF50);
      case OrderStatus.inProcess:
        return AppColors.primaryRed;
      case OrderStatus.completed:
        return const Color(0xFF2196F3);
      case OrderStatus.cancelled:
        return const Color(0xFFF44336);
    }
  }

  IconData _getStatusIcon() {
    switch (order.status) {
      case OrderStatus.ready:
        return Icons.check_circle;
      case OrderStatus.inProcess:
        return Icons.access_time;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  void _cancelOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text(
          'Are you sure you want to cancel order ${order.orderNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Change status to cancelled instead of deleting
              context.read<OrdersCubit>().updateOrderStatus(
                order.id,
                OrderStatus.cancelled,
                'Cancelled',
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStatusDetailDialog(BuildContext context) {
    // Get status detail options based on current order status
    List<String> statusDetails = [];
    switch (order.status) {
      case OrderStatus.ready:
        statusDetails = ['Ready to serve', 'Waiting for pickup'];
        break;
      case OrderStatus.inProcess:
        statusDetails = ['Cooking Now', 'In the kitchen', 'Preparing'];
        break;
      case OrderStatus.completed:
        statusDetails = ['Delivered', 'Picked up', 'Served'];
        break;
      case OrderStatus.cancelled:
        statusDetails = ['Cancelled', 'Refunded'];
        break;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Status Detail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statusDetails.map((detail) {
            return ListTile(
              title: Text(detail),
              leading: Radio<String>(
                value: detail,
                groupValue: order.statusDetail,
                onChanged: (value) {
                  if (value != null) {
                    context.read<OrdersCubit>().updateOrderStatus(
                      order.id,
                      order.status,
                      value,
                    );
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              onTap: () {
                context.read<OrdersCubit>().updateOrderStatus(
                  order.id,
                  order.status,
                  detail,
                );
                Navigator.of(dialogContext).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
