import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Row(
      children: [
        if (responsive.isMobile) ...[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bars, size: 20),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
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
