import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/dashboard/presentation/widgets/dish_item.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class PopularDishesCard extends StatelessWidget {
  final String title;
  final List<DishData> dishes;

  const PopularDishesCard({
    super.key,
    required this.title,
    required this.dishes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final responsive = ResponsiveUtils(context);

    return Container(
      padding: EdgeInsets.all(responsive.cardPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontSize: responsive.responsive(
                      mobile: 16.0,
                      tablet: 18.0,
                      desktop: 18.0,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full list
                },
                child: Text(
                  AppStrings.seeAll,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontSize: responsive.responsive(
                      mobile: 13.0,
                      tablet: 14.0,
                      desktop: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          responsive.isMobile ? 12.h : 16.h,
          ...dishes.map((dish) => DishItem(dish: dish)),
        ],
      ),
    );
  }
}
