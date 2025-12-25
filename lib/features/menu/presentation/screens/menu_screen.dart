import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_header.dart';
import 'package:mrpos/features/menu/presentation/widgets/categories_section.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_tabs.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_items_table.dart';
import 'package:mrpos/features/menu/presentation/widgets/menu_items_card_list.dart';
import 'package:mrpos/features/menu/presentation/widgets/add_menu_item_modal.dart';
import 'package:mrpos/shared/widgets/sidebar_nav.dart';
import 'package:mrpos/shared/widgets/section_header.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCubit(),
      child: const _MenuScreenContent(),
    );
  }
}

class _MenuScreenContent extends StatelessWidget {
  const _MenuScreenContent();

  void _showEditModal(BuildContext context, MenuItem item) {
    final cubit = context.read<MenuCubit>();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Menu Item',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddMenuItemModal(
          itemToEdit: item,
          onSaved: () => cubit.refresh(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
          child: child,
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, MenuItem item) {
    final cubit = context.read<MenuCubit>();

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
            onPressed: () => _handleDelete(context, dialogContext, item, cubit),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleDelete(
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

    cubit.refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu item "${item.name}" deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );

    Navigator.of(dialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;
    final isMobile = size.width <= 600;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: SidebarNav(currentRoute: RouteNames.menu, isDrawer: true),
            )
          : null,
      body: Container(
        color: context.theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuHeader(
                onMenuTap: isMobile
                    ? () => scaffoldKey.currentState?.openDrawer()
                    : null,
              ),
              24.h,
              const CategoriesSection(),
              32.h,
              const SectionHeader(
                title: AppStrings.specialMenuAllItems,
                subtitle: 'Browse and manage all menu items',
              ),
              16.h,
              const MenuTabs(),
              24.h,
              // Use card layout for mobile/tablet, table for desktop
              if (isMobile || isTablet)
                MenuItemsCardList(
                  onEdit: (item) => _showEditModal(context, item),
                  onDelete: (item) => _showDeleteConfirmation(context, item),
                )
              else
                MenuItemsTable(
                  isDark: context.isDarkMode,
                  onEdit: (item) => _showEditModal(context, item),
                  onDelete: (item) => _showDeleteConfirmation(context, item),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
