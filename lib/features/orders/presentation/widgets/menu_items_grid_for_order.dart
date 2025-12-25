import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/orders/presentation/cubit/create_order_cubit.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class MenuItemsGridForOrder extends StatelessWidget {
  const MenuItemsGridForOrder({super.key});

  @override
  Widget build(BuildContext context) {
    // Show ALL items, not just available ones
    final allItems = MenuMockData.menuItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: const Text(
            'Special Menu For You',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
              childAspectRatio: 1.15, // More compact
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              return _MenuItemCard(item: item);
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
    final isOutOfStock = item.quantity <= 0 || !item.isAvailable;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // Dark card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 40,
                    color: isOutOfStock ? Colors.grey[800] : Colors.grey[600],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isOutOfStock ? Colors.grey[600] : Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.h,
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: isOutOfStock
                            ? Colors.grey[700]
                            : Colors.grey[400],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.h,
                    Row(
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isOutOfStock
                                ? Colors.grey[600]
                                : AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                    10.h,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isOutOfStock
                            ? () => _showOutOfStockDialog(context)
                            : () {
                                context.read<CreateOrderCubit>().addItem(item);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOutOfStock
                              ? Colors.grey[800]
                              : AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isOutOfStock ? 'Out of Stock' : '+ Add Product',
                          style: const TextStyle(
                            fontSize: 13,
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
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'OUT OF STOCK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showOutOfStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Out of Stock'),
        content: Text(
          '${item.name} is currently out of stock and cannot be added to your order.',
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
