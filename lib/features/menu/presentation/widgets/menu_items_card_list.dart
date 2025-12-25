import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_item_card.dart';

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
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is! MenuLoaded) return const SizedBox();

        // Filter items by menu type
        final filteredItems = state.menuItems
            .where((item) => item.menuType == state.selectedMenuType)
            .toList();

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
