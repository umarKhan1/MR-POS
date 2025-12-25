import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_item_row.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_table_header.dart';
import 'package:mrpos/shared/theme/app_colors.dart';

/// Widget that displays menu items in a table layout (for desktop)
class MenuItemsTable extends StatelessWidget {
  final bool isDark;
  final Function(dynamic item) onEdit;
  final Function(dynamic item) onDelete;

  const MenuItemsTable({
    super.key,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is! MenuLoaded) return const SizedBox();

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              MenuTableHeader(isDark: isDark),
              // Table Rows
              ...state.menuItems
                  .where((item) => item.menuType == state.selectedMenuType)
                  .map(
                    (item) => MenuItemRow(
                      item: item,
                      isSelected: state.selectedItemIds.contains(item.id),
                      onSelect: () => context
                          .read<MenuCubit>()
                          .toggleItemSelection(item.id),
                      onEdit: () => onEdit(item),
                      onDelete: () => onDelete(item),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
