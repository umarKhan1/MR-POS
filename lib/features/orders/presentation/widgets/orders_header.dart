import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/features/notifications/presentation/widgets/notification_bell.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isMobile ? 0 : 24,
        vertical: responsive.isMobile ? 0 : 16,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A1A)
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          // Hamburger menu on mobile
          if (responsive.isMobile) ...[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.bars,
                size: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            12.w,
          ],
          // Title
          Text(
            'Orders',
            style: TextStyle(
              fontSize: responsive.responsive(
                mobile: 18.0,
                tablet: 20.0,
                desktop: 20.0,
              ),
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          // Add New Order button
          if (!responsive.isMobile) ...[
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            16.w,
          ] else ...[
            // Mobile: Just icon button
            IconButton(
              icon: const Icon(Icons.add, size: 24),
              onPressed: () => context.go('/create-order'),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
            12.w,
          ],
          // Notification icon
          NotificationBell(color: isDark ? Colors.white : Colors.black),
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
