import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class OrdersShimmer extends StatelessWidget {
  const OrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    final isDark = context.isDarkMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = responsive.responsive(
          mobile: 1,
          tablet: 2,
          desktop: 3,
        );

        final spacing = responsive.isMobile ? 12.0 : 16.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final cardWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Shimmer.fromColors(
          baseColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[300]!,
          highlightColor: isDark ? const Color(0xFF3A3A3A) : Colors.grey[100]!,
          child: Wrap(
            spacing: spacing,
            runSpacing: responsive.isMobile ? 12.0 : 15.0,
            children: List.generate(
              6,
              (index) => Container(
                width: cardWidth,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
