import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class OrdersHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const OrdersHeader({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
      child: Row(
        children: [
          // Title
          const Text(
            'Orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // Add New Order button
          ElevatedButton.icon(
            onPressed: () => context.go('/create-order'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Add New Order',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          16.w,
          // Notification icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
          12.w,
          // Profile icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white, size: 20),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
