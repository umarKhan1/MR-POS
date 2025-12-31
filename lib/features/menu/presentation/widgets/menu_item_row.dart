import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class MenuItemRow extends StatefulWidget {
  final MenuItem item;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MenuItemRow({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<MenuItemRow> createState() => _MenuItemRowState();
}

class _MenuItemRowState extends State<MenuItemRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isDark ? const Color(0xFF333333) : const Color(0xFFF8F8F8))
              : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
          borderRadius: BorderRadius.circular(8),
          border: widget.isSelected
              ? Border.all(color: AppColors.primaryRed, width: 2)
              : Border.all(
                  color: isDark
                      ? const Color(0xFF3A3A3A)
                      : const Color(0xFFE0E0E0),
                  width: 1,
                ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        transform: Matrix4.identity()..scale(_isHovered ? 1.005 : 1.0),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: widget.isSelected,
              onChanged: (value) => widget.onSelect?.call(),
              activeColor: AppColors.primaryRed,
            ),
            16.w,
            // Product Image & Info
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.item.image.startsWith('http')
                  ? Image.network(
                      widget.item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : Image.asset(
                      widget.item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    ),
            ),
            16.w,
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      fontSize: 14,
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
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            16.w,
            // Item ID
            Expanded(
              child: Text(
                widget.item.itemId,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Stock
            Expanded(
              child: Text(
                widget.item.stockStatusDisplay,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 13,
                ),
              ),
            ),
            // Category
            Expanded(
              child: Text(
                widget.item.category,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontSize: 13,
                ),
              ),
            ),
            // Price
            Expanded(
              child: Text(
                '\$${widget.item.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Availability
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.item.isAvailable
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: widget.item.isAvailable
                        ? AppColors.success.withValues(alpha: 0.3)
                        : AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
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
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Actions
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.6,
              duration: const Duration(milliseconds: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionButton(
                    icon: FontAwesomeIcons.penToSquare,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    onPressed: widget.onEdit,
                  ),
                  _ActionButton(
                    icon: FontAwesomeIcons.trash,
                    color: AppColors.error,
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.restaurant, size: 28),
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
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: IconButton(
          icon: FaIcon(widget.icon, size: 16),
          onPressed: widget.onPressed,
          color: _isHovered ? widget.color : widget.color.withOpacity(0.7),
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
