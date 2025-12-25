import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';

/// Helper class for menu item operations
class MenuItemHelper {
  /// Shows edit modal for a menu item
  static void showEditModal(
    BuildContext context,
    MenuItem item,
    MenuCubit cubit,
  ) {
    // Import moved to avoid circular dependency
    // This will be imported in the screen file
    throw UnimplementedError('Import AddMenuItemModal in screen file');
  }

  /// Shows delete confirmation dialog and handles deletion
  static void showDeleteConfirmation(
    BuildContext context,
    MenuItem item,
    MenuCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _deleteMenuItem(context, dialogContext, item, cubit);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Deletes a menu item and updates category count
  static void _deleteMenuItem(
    BuildContext context,
    BuildContext dialogContext,
    MenuItem item,
    MenuCubit cubit,
  ) {
    // Delete the item
    MenuMockData.menuItems.removeWhere((i) => i.id == item.id);

    // Update category item count
    final category = MenuMockData.categories.firstWhere(
      (cat) => cat.name == item.category,
      orElse: () => MenuMockData.categories.first,
    );
    final categoryIndex = MenuMockData.categories.indexWhere(
      (cat) => cat.id == category.id,
    );
    if (categoryIndex != -1 && category.itemCount > 0) {
      MenuMockData.categories[categoryIndex] = MenuCategory(
        id: category.id,
        name: category.name,
        iconAsset: category.iconAsset,
        iconData: category.iconData,
        itemCount: category.itemCount - 1,
        iconKey: category.iconKey,
        description: category.description,
      );
    }

    // Refresh UI
    cubit.refresh();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu item "${item.name}" deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );

    Navigator.of(dialogContext).pop();
  }
}
