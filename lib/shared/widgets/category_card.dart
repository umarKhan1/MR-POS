import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class CategoryCard extends StatefulWidget {
  final MenuCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
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
            padding: const EdgeInsets.all(16),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(isHovered ? 1.1 : 1.0),
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
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (widget.category.iconAsset != null) {
      return Image.asset(
        widget.category.iconAsset!,
        width: 40,
        height: 40,
        color: widget.isSelected ? Colors.white : AppColors.primaryRed,
        errorBuilder: (context, error, stackTrace) {
          return const FaIcon(
            FontAwesomeIcons.utensils,
            size: 40,
            color: AppColors.primaryRed,
          );
        },
      );
    } else if (widget.category.iconData != null) {
      return FaIcon(
        widget.category.iconData!,
        size: 40,
        color: widget.isSelected ? Colors.white : AppColors.primaryRed,
      );
    }
    return const FaIcon(
      FontAwesomeIcons.utensils,
      size: 40,
      color: AppColors.primaryRed,
    );
  }
}
