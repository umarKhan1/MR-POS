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
import 'package:mrpos/shared/utils/responsive_utils.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final int orderIndex;

  const OrderCard({super.key, required this.order, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(
        responsive.responsive(mobile: 10.0, tablet: 12.0, desktop: 14.0),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: order.status == OrderStatus.awaited
            ? Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.5),
                width: 2,
              )
            : Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.05,
                ),
              ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: responsive.responsive(
                  mobile: 36.0,
                  tablet: 40.0,
                  desktop: 46.0,
                ),
                height: responsive.responsive(
                  mobile: 36.0,
                  tablet: 40.0,
                  desktop: 46.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    orderIndex.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.responsive(
                        mobile: 14.0,
                        tablet: 16.0,
                        desktop: 18.0,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              responsive.responsive(mobile: 6.w, tablet: 8.w, desktop: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: responsive.responsive(
                          mobile: 12.0,
                          tablet: 13.0,
                          desktop: 14.0,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          'Order ${order.orderNumber}',
                          style: TextStyle(
                            color: (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.5),
                            fontSize: responsive.responsive(
                              mobile: 9.0,
                              tablet: 10.0,
                              desktop: 11.0,
                            ),
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
              _buildStatusBadge(responsive),
            ],
          ),
          responsive.responsive(mobile: 4.h, tablet: 5.h, desktop: 6.h),
          // Status detail dropdown
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _showStatusDetailDialog(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.responsive(
                    mobile: 6.0,
                    tablet: 8.0,
                    desktop: 10.0,
                  ),
                  vertical: responsive.responsive(
                    mobile: 4.0,
                    tablet: 4.0,
                    desktop: 5.0,
                  ),
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.statusDetail,
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.7),
                        fontSize: responsive.responsive(
                          mobile: 8.0,
                          tablet: 9.0,
                          desktop: 10.0,
                        ),
                      ),
                    ),
                    4.w,
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.5,
                      ),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          responsive.responsive(mobile: 4.h, tablet: 5.h, desktop: 6.h),
          // Items table
          Container(
            padding: EdgeInsets.all(
              responsive.responsive(mobile: 6.0, tablet: 8.0, desktop: 10.0),
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table header
                Row(
                  children: [
                    SizedBox(
                      width: responsive.responsive(
                        mobile: 24.0,
                        tablet: 28.0,
                        desktop: 32.0,
                      ),
                      child: Text(
                        'Qty',
                        style: TextStyle(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.4),
                          fontSize: responsive.responsive(
                            mobile: 8.0,
                            tablet: 9.0,
                            desktop: 10.0,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Items',
                        style: TextStyle(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.4),
                          fontSize: responsive.responsive(
                            mobile: 8.0,
                            tablet: 9.0,
                            desktop: 10.0,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Price',
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.4),
                        fontSize: responsive.responsive(
                          mobile: 8.0,
                          tablet: 9.0,
                          desktop: 10.0,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                responsive.responsive(mobile: 2.h, tablet: 3.h, desktop: 4.h),
                // Items
                ...order.items.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(
                      bottom: responsive.responsive(
                        mobile: 2.0,
                        tablet: 3.0,
                        desktop: 4.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: responsive.responsive(
                            mobile: 24.0,
                            tablet: 28.0,
                            desktop: 32.0,
                          ),
                          child: Text(
                            item.quantity.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: responsive.responsive(
                                mobile: 9.0,
                                tablet: 10.0,
                                desktop: 11.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: responsive.responsive(
                                mobile: 9.0,
                                tablet: 10.0,
                                desktop: 11.0,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${item.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: responsive.responsive(
                              mobile: 9.0,
                              tablet: 10.0,
                              desktop: 11.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          responsive.responsive(mobile: 4.h, tablet: 5.h, desktop: 6.h),
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SubTotal',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: responsive.responsive(
                    mobile: 10.0,
                    tablet: 11.0,
                    desktop: 12.0,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${order.subtotal.toStringAsFixed(0)}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: responsive.responsive(
                    mobile: 10.0,
                    tablet: 11.0,
                    desktop: 12.0,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          responsive.responsive(mobile: 6.h, tablet: 7.h, desktop: 8.h),
          // Action buttons - only show for active orders (awaited)
          if (order.status == OrderStatus.awaited) ...[
            Row(
              children: [
                _buildActionButton(
                  context: context,
                  icon: FontAwesomeIcons.penToSquare,
                  onPressed: () {
                    GoRouter.of(
                      context,
                    ).push('/create-order?orderId=${order.id}');
                  },
                  responsive: responsive,
                ),
                8.w,
                _buildActionButton(
                  context: context,
                  icon: FontAwesomeIcons.trash,
                  onPressed: () => _cancelOrder(context),
                  responsive: responsive,
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
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.responsive(
                            mobile: 7.0,
                            tablet: 8.0,
                            desktop: 9.0,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Pay Bill',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: responsive.responsive(
                                mobile: 10.0,
                                tablet: 11.0,
                                desktop: 12.0,
                              ),
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

  Widget _buildStatusBadge(ResponsiveUtils responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isMobile ? 8 : 10,
        vertical: 5,
      ),
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
          Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: responsive.isMobile ? 10 : 11,
          ),
          responsive.isMobile ? 4.w : 5.w,
          Text(
            order.status.displayName,
            style: TextStyle(
              color: _getStatusColor(),
              fontSize: responsive.isMobile ? 10 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required ResponsiveUtils responsive,
  }) {
    final isDark = context.isDarkMode;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: responsive.isMobile ? 36 : 40,
          height: responsive.isMobile ? 36 : 40,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.1,
              ),
            ),
          ),
          child: Center(
            child: FaIcon(
              icon,
              size: responsive.isMobile ? 12 : 14,
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.confirmed:
        return const Color(0xFFD32F2F); // Strong Red
      case OrderStatus.awaited:
        return const Color(0xFFE57373); // Coral/Pink
      case OrderStatus.cancelled:
        return const Color(0xFFEF9A9A); // Light Coral
      case OrderStatus.failed:
        return const Color(0xFFFFCDD2); // Very Light Pink
    }
  }

  IconData _getStatusIcon() {
    switch (order.status) {
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.awaited:
        return Icons.access_time;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.failed:
        return Icons.error_outline;
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
      case OrderStatus.confirmed:
        statusDetails = ['Confirmed', 'Ready to serve', 'Served'];
        break;
      case OrderStatus.awaited:
        statusDetails = ['Awaited', 'In the kitchen', 'Preparing'];
        break;
      case OrderStatus.failed:
        statusDetails = ['Failed', 'Payment Failed', 'System Error'];
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
