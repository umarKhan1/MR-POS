import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const DashboardHeader({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;

    return Row(
      children: [
        if (isMobile) ...[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bars, size: 20),
            onPressed: onMenuTap,
            color: context.isDarkMode
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          12.w,
        ],
        Text(AppStrings.dashboard, style: context.textTheme.headlineMedium),
        const Spacer(),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.bell, size: 20),
          onPressed: () {
            // TODO: Handle notifications
          },
          color: context.isDarkMode
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
        12.w,
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryRed,
          child: const FaIcon(
            FontAwesomeIcons.user,
            size: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
