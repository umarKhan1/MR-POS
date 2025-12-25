import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MenuItemCard({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: widget.isSelected
              ? Border.all(color: AppColors.primaryRed, width: 2)
              : null,
          boxShadow: [
            if (widget.isSelected)
              BoxShadow(
                color: AppColors.primaryRed.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              )
            else if (_isHovered)
              BoxShadow(
                color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        transform: Matrix4.identity()..scale(_isHovered ? 1.01 : 1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: widget.isSelected,
                  onChanged: (value) => widget.onSelect?.call(),
                  activeColor: AppColors.primaryRed,
                ),
                12.w,
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.item.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.restaurant, size: 32),
                      );
                    },
                  ),
                ),
                16.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      4.h,
                      Text(
                        widget.item.description,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.h,
            Divider(
              color: isDark
                  ? AppColors.greyDark.withValues(alpha: 0.3)
                  : AppColors.greyLight.withValues(alpha: 0.3),
            ),
            12.h,
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.qr_code,
                    label: 'ID',
                    value: widget.item.itemId,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.inventory_2_outlined,
                    label: AppStrings.stock,
                    value: widget.item.stockStatusDisplay,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            12.h,
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.category_outlined,
                    label: AppStrings.category,
                    value: widget.item.category,
                    isDark: isDark,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.attach_money,
                    label: AppStrings.price,
                    value: '\$${widget.item.price.toStringAsFixed(2)}',
                    isDark: isDark,
                    isPrice: true,
                  ),
                ),
              ],
            ),
            16.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.item.isAvailable
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.item.isAvailable
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.item.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 14,
                        color: widget.item.isAvailable
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      6.w,
                      Text(
                        widget.item.isAvailable
                            ? AppStrings.inStock
                            : AppStrings.outOfStock,
                        style: TextStyle(
                          color: widget.item.isAvailable
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: FontAwesomeIcons.penToSquare,
                      color: AppColors.primaryRed,
                      onPressed: widget.onEdit,
                    ),
                    8.w,
                    _ActionButton(
                      icon: FontAwesomeIcons.trash,
                      color: AppColors.error,
                      onPressed: widget.onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool isPrice = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        8.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
              2.h,
              Text(
                value,
                style: TextStyle(
                  color: isPrice
                      ? AppColors.primaryRed
                      : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  fontSize: 14,
                  fontWeight: isPrice ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: IconButton(
          icon: FaIcon(widget.icon, size: 18),
          onPressed: widget.onPressed,
          color: widget.color,
          style: IconButton.styleFrom(
            backgroundColor: _isHovered
                ? widget.color.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
