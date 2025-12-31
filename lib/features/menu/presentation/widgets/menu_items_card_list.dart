import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_item_card.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_shimmer.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_empty_state.dart';
import 'package:mrpos/shared/utils/extensions.dart';

/// Widget that displays menu items in a card layout (for mobile/tablet)
class MenuItemsCardList extends StatelessWidget {
  final Function(dynamic item) onEdit;
  final Function(dynamic item) onDelete;

  const MenuItemsCardList({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is MenuLoading) {
          return MenuShimmer(isTable: false, isDark: isDark);
        }

        if (state is! MenuLoaded) return const SizedBox();

        // Filter items by menu type and category
        final selectedCategory = state.categories
            .where((c) => c.id == state.selectedCategoryId)
            .firstOrNull;

        final filteredItems = state.menuItems.where((item) {
          final matchesMenuType =
              state.selectedMenuType == 'All' ||
              item.menuType == state.selectedMenuType;
          final matchesCategory =
              state.selectedCategoryId == '1' ||
              (selectedCategory != null &&
                  item.category == selectedCategory.name);
          return matchesMenuType && matchesCategory;
        }).toList();

        if (filteredItems.isEmpty) {
          return const MenuEmptyState(
            title: 'No Menu Items',
            message: 'No items found for this menu type. Add your first item!',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filteredItems
              .map(
                (item) => MenuItemCard(
                  item: item,
                  isSelected: state.selectedItemIds.contains(item.id),
                  onSelect: () =>
                      context.read<MenuCubit>().toggleItemSelection(item.id),
                  onEdit: () => onEdit(item),
                  onDelete: () => onDelete(item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
