import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class DishItem extends StatelessWidget {
  final DishData dish;

  const DishItem({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final responsive = ResponsiveUtils(context);

    final imageSize = responsive.responsive(
      mobile: 45.0,
      tablet: 50.0,
      desktop: 50.0,
    );

    return Container(
      margin: EdgeInsets.only(bottom: responsive.isMobile ? 8 : 12),
      padding: EdgeInsets.all(responsive.isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: dish.inStock
                  ? AppColors.primaryRed.withValues(alpha: 0.1)
                  : AppColors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(dish.category),
              color: dish.inStock ? AppColors.primaryRed : AppColors.grey,
              size: imageSize * 0.6,
            ),
          ),
          responsive.isMobile ? 8.w : 12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontSize: responsive.responsive(
                      mobile: 13.0,
                      tablet: 14.0,
                      desktop: 14.0,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.h,
                Text(
                  dish.metadata,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: responsive.responsive(
                      mobile: 11.0,
                      tablet: 12.0,
                      desktop: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dish.inStock ? AppStrings.inStock : AppStrings.outOfStock,
                style: TextStyle(
                  color: dish.inStock ? AppColors.success : AppColors.error,
                  fontSize: responsive.responsive(
                    mobile: 10.0,
                    tablet: 11.0,
                    desktop: 11.0,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.h,
              Text(
                '\$${dish.orderPrice?.toStringAsFixed(2) ?? dish.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: responsive.responsive(
                    mobile: 13.0,
                    tablet: 14.0,
                    desktop: 14.0,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.restaurant;
    final cat = category.toLowerCase();
    if (cat.contains('pizza')) return Icons.local_pizza;
    if (cat.contains('burger')) return Icons.lunch_dining;
    if (cat.contains('chicken')) return Icons.kebab_dining;
    if (cat.contains('seafood') || cat.contains('fish')) return Icons.flatware;
    if (cat.contains('desert') || cat.contains('sweet'))
      return Icons.bakery_dining;
    if (cat.contains('drink') || cat.contains('beverage'))
      return Icons.local_drink;
    return Icons.restaurant;
  }
}
