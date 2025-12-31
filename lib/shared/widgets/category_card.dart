import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class CategoryCard extends StatefulWidget {
  final MenuCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 120,
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.primaryRed
                  : isHovered
                  ? (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF0F0F0))
                  : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
              borderRadius: BorderRadius.circular(12),
              border: widget.isSelected
                  ? Border.all(color: AppColors.primaryRed, width: 2)
                  : null,
              boxShadow: [
                if (widget.isSelected)
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                else if (isHovered)
                  BoxShadow(
                    color: isDark
                        ? AppColors.shadowDark
                        : AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: isDark
                        ? AppColors.shadowDark
                        : AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..scale(isHovered ? 1.1 : 1.0),
                        child: _buildIcon(),
                      ),
                      12.h,
                      // Category Name
                      Text(
                        widget.category.name,
                        style: TextStyle(
                          color: widget.isSelected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.h,
                      // Item Count
                      Text(
                        '${widget.category.itemCount} ${AppStrings.items}',
                        style: TextStyle(
                          color: widget.isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isHovered || widget.isSelected)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.onEdit != null)
                          _ActionButton(
                            icon: Icons.edit,
                            onTap: widget.onEdit!,
                            color: widget.isSelected
                                ? Colors.white
                                : AppColors.primaryRed,
                            backgroundColor: widget.isSelected
                                ? Colors.white.withValues(alpha: 0.25)
                                : (isDark
                                      ? const Color(0xFF444444)
                                      : Colors.white),
                          ),
                        if (widget.onDelete != null) ...[
                          6.w,
                          _ActionButton(
                            icon: Icons.delete_outline,
                            onTap: widget.onDelete!,
                            color: widget.isSelected
                                ? Colors.white
                                : AppColors.error,
                            backgroundColor: widget.isSelected
                                ? Colors.white.withValues(alpha: 0.25)
                                : (isDark
                                      ? const Color(0xFF444444)
                                      : Colors.white),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return FaIcon(
      widget.category.iconData,
      size: 40,
      color: widget.isSelected ? Colors.white : AppColors.primaryRed,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color backgroundColor;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 13, color: color),
        ),
      ),
    );
  }
}
