import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:go_router/go_router.dart';

class SidebarNav extends StatefulWidget {
  final String? currentRoute;
  final bool isDrawer;

  const SidebarNav({super.key, this.currentRoute, this.isDrawer = false});

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> {
  String? hoveredRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isDrawer ? double.infinity : 240,
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          24.h,
          _buildLogo(),
          40.h,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavItem(
                    icon: FontAwesomeIcons.house,
                    label: AppStrings.dashboard,
                    route: RouteNames.dashboard,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.utensils,
                    label: AppStrings.menuNav,
                    route: RouteNames.menu,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.userGroup,
                    label: AppStrings.staff,
                    route: RouteNames.staff,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.chartLine,
                    label: AppStrings.reports,
                    route: RouteNames.reports,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.clipboardList,
                    label: AppStrings.orderTable,
                    route: RouteNames.orderTable,
                  ),
                  _buildNavItem(
                    icon: FontAwesomeIcons.calendarCheck,
                    label: AppStrings.reservation,
                    route: RouteNames.reservation,
                  ),
                ],
              ),
            ),
          ),
          _buildNavItem(
            icon: FontAwesomeIcons.rightFromBracket,
            label: AppStrings.logout,
            route: RouteNames.login,
            isLogout: true,
          ),
          24.h,
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            AppConstants.appName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String route,
    bool isLogout = false,
  }) {
    final isActive = widget.currentRoute == route;
    final isHovered = hoveredRoute == route;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredRoute = route),
      onExit: (_) => setState(() => hoveredRoute = null),
      child: GestureDetector(
        onTap: () {
          if (isLogout) {
            // TODO: Handle logout
            context.go(RouteNames.login);
          } else {
            context.go(route);
          }

          // Close drawer on mobile after navigation
          if (widget.isDrawer) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryRed
                : isHovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              FaIcon(icon, color: Colors.white, size: 18),
              16.w,
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
