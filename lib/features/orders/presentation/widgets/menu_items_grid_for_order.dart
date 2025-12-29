import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_cubit.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class MenuItemsGridForOrder extends StatelessWidget {
  const MenuItemsGridForOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    // Show ALL items, not just available ones
    final allItems = MenuMockData.menuItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(
            responsive.responsive(mobile: 16.0, tablet: 18.0, desktop: 20.0),
          ),
          child: Text(
            'Special Menu For You',
            style: TextStyle(
              fontSize: responsive.responsive(
                mobile: 18.0,
                tablet: 19.0,
                desktop: 20.0,
              ),
              fontWeight: FontWeight.w700,
              color: context.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              // Determine columns based on AVAILABLE width, not screen width
              int crossAxisCount = 1;
              if (availableWidth > 800) {
                crossAxisCount = 3;
              } else if (availableWidth > 500) {
                crossAxisCount = 2;
              }

              final spacing = responsive.responsive(
                mobile: 12.0,
                tablet: 16.0,
                desktop: 20.0,
              );

              // Calculate card width as a portion of available width minus total spacing gaps
              final totalSpacing = spacing * (crossAxisCount + 1);
              final cardWidth =
                  (availableWidth - totalSpacing) / crossAxisCount;

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: spacing,
                  right: spacing,
                  bottom: spacing,
                ),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: allItems.map((item) {
                    return SizedBox(
                      width: cardWidth,
                      child: _MenuItemCard(item: item),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isOutOfStock = item.quantity <= 0 || !item.isAvailable;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        // Determine internal scaling based on card width
        final isSmallCard = cardWidth < 180;
        final isMediumCard = cardWidth < 280;

        final imageHeight = isSmallCard ? 80.0 : (isMediumCard ? 95.0 : 110.0);
        final iconSize = isSmallCard ? 24.0 : (isMediumCard ? 32.0 : 40.0);
        final padding = isSmallCard ? 6.0 : (isMediumCard ? 10.0 : 12.0);
        final titleSize = isSmallCard ? 11.0 : (isMediumCard ? 13.0 : 14.0);
        final descSize = isSmallCard ? 8.0 : (isMediumCard ? 10.0 : 11.0);
        final priceSize = isSmallCard ? 12.0 : (isMediumCard ? 14.0 : 16.0);
        final verticalSpacingScale = isSmallCard
            ? 0.5
            : (isMediumCard ? 0.8 : 1.0);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : Colors.grey).withValues(
                  alpha: 0.1,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    height: imageHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1A1A1A)
                          : Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant,
                        size: iconSize,
                        color: isOutOfStock
                            ? Colors.grey[800]
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                            color: isOutOfStock
                                ? Colors.grey[isDark ? 800 : 400]
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        (4 * verticalSpacingScale).h,
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: descSize,
                            color: isOutOfStock
                                ? Colors.grey[isDark ? 900 : 300]
                                : (isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        (8 * verticalSpacingScale).h,
                        Row(
                          children: [
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: priceSize,
                                fontWeight: FontWeight.w700,
                                color: isOutOfStock
                                    ? Colors.grey[600]
                                    : AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                        (10 * verticalSpacingScale).h,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isOutOfStock
                                ? () => _showOutOfStockDialog(context)
                                : () {
                                    context.read<CreateOrderCubit>().addItem(
                                      item,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isOutOfStock
                                  ? Colors.grey[800]
                                  : AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallCard
                                    ? 6.0
                                    : (isMediumCard ? 8.0 : 10.0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isOutOfStock ? 'Out of Stock' : '+ Add Product',
                              style: TextStyle(
                                fontSize: isSmallCard
                                    ? 10.0
                                    : (isMediumCard ? 12.0 : 13.0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Out of stock badge
              if (isOutOfStock)
                Positioned(
                  top: padding,
                  right: padding,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OUT OF STOCK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallCard ? 7 : 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showOutOfStockDialog(BuildContext context) {
    final isDark = context.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        title: Text(
          'Out of Stock',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Text(
          '${item.name} is currently out of stock and cannot be added to your order.',
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
