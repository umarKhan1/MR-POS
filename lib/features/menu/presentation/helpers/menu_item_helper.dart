import 'package:flutter/material.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';

/// Helper class for menu item operations
class MenuItemHelper {
  /// Shows edit modal for a menu item
  static void showEditModal(
    BuildContext context,
    MenuItem item,
    MenuCubit cubit,
  ) {
    // This helper seems to be a placeholder or legacy from mock setup.
    // In the new Firestore implementation, we handle screen transitions directly in the Screen or Widget.
    throw UnimplementedError(
      'Handle edit modal in the UI layer (MenuScreen/MenuItemCard)',
    );
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

  /// Deletes a menu item from Firestore
  static void _deleteMenuItem(
    BuildContext context,
    BuildContext dialogContext,
    MenuItem item,
    MenuCubit cubit,
  ) {
    // Delete from Firestore
    cubit.deleteMenuItem(item.id);

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
