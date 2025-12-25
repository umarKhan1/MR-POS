import 'package:flutter/material.dart';
import 'package:mrpos/shared/theme/app_colors.dart';

/// A reusable button widget with consistent styling across the app.
///
/// **Usage:**
/// ```dart
/// // Primary button with red background (recommended for main actions)
/// CustomButton.primary(
///   text: 'Add Item',
///   onPressed: () {},
/// )
///
/// // Outlined button with red border
/// CustomButton.outlined(
///   text: 'Cancel',
///   onPressed: () {},
/// )
///
/// // Custom button with specific colors
/// CustomButton(
///   text: 'Custom',
///   onPressed: () {},
///   backgroundColor: Colors.blue,
///   textColor: Colors.white,
/// )
/// ```
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.borderRadius = 12,
    this.padding,
  });

  /// Primary button with red background and white text
  const CustomButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.borderRadius = 8,
    this.padding,
  }) : isOutlined = false,
       backgroundColor = AppColors.primaryRed,
       textColor = Colors.white;

  /// Outlined button with red border and red text
  const CustomButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.borderRadius = 8,
    this.padding,
  }) : isOutlined = true,
       backgroundColor = AppColors.primaryRed,
       textColor = AppColors.primaryRed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBgColor = backgroundColor ?? theme.primaryColor;
    final defaultTextColor = textColor ?? Colors.white;

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height ?? 56,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: defaultBgColor,
            side: BorderSide(color: defaultBgColor, width: 2),
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildButtonContent(defaultBgColor),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBgColor,
          foregroundColor: defaultTextColor,
          elevation: 0,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _buildButtonContent(defaultTextColor),
      ),
    );
  }

  Widget _buildButtonContent(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
    );
  }
}
