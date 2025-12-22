import 'package:flutter/material.dart';
import 'package:mrpos/shared/theme/app_colors.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryRed, AppColors.darkRed],
        ),
      ),
      child: Stack(
        children: [
          _buildCircle(
            top: -100,
            left: -100,
            size: 300,
            color: AppColors.circleBlue,
            opacity: 0.3,
          ),
          _buildCircle(
            top: -50,
            left: -50,
            size: 200,
            color: AppColors.circleWhite,
            opacity: 0.1,
          ),
          _buildCircle(
            bottom: -150,
            left: -150,
            size: 400,
            color: Colors.black,
            opacity: 0.2,
          ),
          _buildCircle(
            bottom: -100,
            left: -100,
            size: 300,
            color: AppColors.circleWhite,
            opacity: 0.1,
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: opacity), width: 2),
        ),
      ),
    );
  }
}
