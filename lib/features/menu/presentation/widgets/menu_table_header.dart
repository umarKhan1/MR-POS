import 'package:flutter/material.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

/// Table header widget for menu items table
class MenuTableHeader extends StatelessWidget {
  final bool isDark;

  const MenuTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 40), // Checkbox space
          16.w,
          const SizedBox(width: 60), // Image space
          16.w,
          Expanded(
            flex: 2,
            child: _buildHeaderText(AppStrings.productName, isDark),
          ),
          16.w,
          Expanded(child: _buildHeaderText(AppStrings.itemID, isDark)),
          Expanded(child: _buildHeaderText(AppStrings.stock, isDark)),
          Expanded(child: _buildHeaderText(AppStrings.category, isDark)),
          Expanded(child: _buildHeaderText(AppStrings.price, isDark)),
          Expanded(child: _buildHeaderText(AppStrings.availability, isDark)),
          const SizedBox(width: 100), // Actions space
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w700,
        fontSize: 13,
        letterSpacing: 0.3,
      ),
    );
  }
}
