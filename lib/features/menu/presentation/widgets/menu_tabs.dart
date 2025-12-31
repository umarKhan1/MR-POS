import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';
import 'package:mrpos/features/menu/presentation/widgets/add_menu_item_modal.dart';
import 'package:mrpos/features/menu/presentation/widgets/add_menu_type_modal.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/widgets/custom_button.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class MenuTabs extends StatelessWidget {
  const MenuTabs({super.key});

  void _showAddMenuTypeModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Menu Type',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const AddMenuTypeModal();
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

  void _showEditMenuTypeModal(BuildContext context, MenuType menuType) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit Menu Type',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AddMenuTypeModal(menuTypeToEdit: menuType);
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

  void _showDeleteConfirmation(BuildContext context, MenuType menuType) {
    final cubit = context.read<MenuCubit>();
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Delete Menu Type',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${menuType.name}"?\n\nMenu items with this type will not be deleted, but won\'t appear in any tab.',
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Delete the menu type from Firestore
              cubit.deleteMenuType(menuType.id);

              Navigator.of(dialogContext).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Menu type "${menuType.name}" deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is! MenuLoaded) return const SizedBox();

        final menuTypes = state.menuTypes;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Tabs
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // "All" tab
                _MenuTypeTab(
                  menuType: const MenuType(
                    id: 'all',
                    name: 'All',
                    displayOrder: -1,
                  ),
                  isSelected: state.selectedMenuType == 'All',
                  isDark: isDark,
                  onTap: () => context.read<MenuCubit>().selectMenuType('All'),
                  onEdit: null,
                  onDelete: null,
                ),

                // Menu type tabs
                ...menuTypes.map((menuType) {
                  final isSelected = state.selectedMenuType == menuType.name;
                  return _MenuTypeTab(
                    menuType: menuType,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () =>
                        context.read<MenuCubit>().selectMenuType(menuType.name),
                    onEdit: () => _showEditMenuTypeModal(context, menuType),
                    onDelete: () => _showDeleteConfirmation(context, menuType),
                  );
                }),

                // Add Menu Type button
                _AddMenuTypeButton(
                  isDark: isDark,
                  onTap: () => _showAddMenuTypeModal(context),
                ),
              ],
            ),

            CustomButton.primary(
              text: 'Add Menu Item',
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Add Menu Item',
                  barrierColor: Colors.black54,
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const AddMenuItemModal();
                  },
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                          child: child,
                        );
                      },
                );
              },
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ],
        );
      },
    );
  }
}

class _MenuTypeTab extends StatefulWidget {
  final MenuType menuType;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _MenuTypeTab({
    required this.menuType,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_MenuTypeTab> createState() => _MenuTypeTabState();
}

class _MenuTypeTabState extends State<_MenuTypeTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primaryRed
                : _isHovered
                ? (widget.isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFEEEEEE))
                : (widget.isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              else if (_isHovered)
                BoxShadow(
                  color: widget.isDark
                      ? AppColors.shadowDark
                      : AppColors.shadowLight,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.menuType.name,
                style: TextStyle(
                  color: widget.isSelected
                      ? Colors.white
                      : (widget.isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
              if (widget.onEdit != null || widget.onDelete != null)
                const SizedBox(width: 8),
              // Edit icon
              if (widget.onEdit != null)
                _TabIconButton(
                  icon: Icons.edit,
                  onTap: widget.onEdit!,
                  color: widget.isSelected
                      ? Colors.white.withOpacity(0.9)
                      : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                ),
              if (widget.onEdit != null && widget.onDelete != null)
                const SizedBox(width: 4),
              // Delete icon
              if (widget.onDelete != null)
                _TabIconButton(
                  icon: Icons.close,
                  onTap: widget.onDelete!,
                  color: widget.isSelected
                      ? Colors.white.withOpacity(0.9)
                      : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _TabIconButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  State<_TabIconButton> createState() => _TabIconButtonState();
}

class _TabIconButtonState extends State<_TabIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Icon(widget.icon, size: 16, color: widget.color),
        ),
      ),
    );
  }
}

class _AddMenuTypeButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _AddMenuTypeButton({required this.isDark, required this.onTap});

  @override
  State<_AddMenuTypeButton> createState() => _AddMenuTypeButtonState();
}

class _AddMenuTypeButtonState extends State<_AddMenuTypeButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFEEEEEE))
                : (widget.isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primaryRed.withOpacity(0.5)
                  : (widget.isDark
                        ? const Color(0xFF3A3A3A)
                        : const Color(0xFFE0E0E0)),
              width: 1,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: widget.isDark
                      ? AppColors.shadowDark
                      : AppColors.shadowLight,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                size: 18,
                color: _isHovered
                    ? AppColors.primaryRed
                    : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
              ),
              const SizedBox(width: 4),
              Text(
                'Add Menu Type',
                style: TextStyle(
                  color: _isHovered
                      ? AppColors.primaryRed
                      : (widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
