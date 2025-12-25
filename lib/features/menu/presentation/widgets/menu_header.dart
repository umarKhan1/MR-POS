import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class MenuHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const MenuHeader({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            _HoverIconButton(
              icon: const FaIcon(FontAwesomeIcons.bars, size: 20),
              onPressed: onMenuTap,
              isDark: isDark,
            ),
            12.w,
          ],
          Text(
            AppStrings.menu,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _NotificationButton(isDark: isDark),
          12.w,
          _UserAvatar(),
        ],
      ),
    );
  }
}

class _HoverIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isDark;

  const _HoverIconButton({
    required this.icon,
    this.onPressed,
    required this.isDark,
  });

  @override
  State<_HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered
              ? (widget.isDark ? AppColors.hoverDark : AppColors.hoverLight)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: widget.icon,
          onPressed: widget.onPressed,
          color: widget.isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  final bool isDark;

  const _NotificationButton({required this.isDark});

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isHovered
              ? (widget.isDark ? AppColors.hoverDark : AppColors.hoverLight)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
              onPressed: () {
                // TODO: Handle notifications
              },
              color: widget.isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            // Notification badge
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isDark
                        ? AppColors.cardDark
                        : AppColors.cardLight,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatefulWidget {
  @override
  State<_UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<_UserAvatar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isHovered
                ? const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  )
                : null,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primaryRed.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryRed,
            child: const FaIcon(
              FontAwesomeIcons.user,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
