import 'package:flutter/material.dart';
import 'package:mrpos/shared/widgets/sidebar_nav.dart';
import 'package:mrpos/shared/utils/responsive_utils.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // Get current route for sidebar highlighting
        final currentRoute = GoRouterState.of(context).uri.toString();

        if (responsive.isMobile) {
          // Mobile: Use drawer
          return _MobileLayout(currentRoute: currentRoute, child: child);
        } else {
          // Tablet/Desktop: Persistent sidebar
          return _DesktopLayout(currentRoute: currentRoute, child: child);
        }
      },
    );
  }
}

/// Desktop/Tablet layout with persistent sidebar
class _DesktopLayout extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const _DesktopLayout({required this.currentRoute, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar - stays fixed
          SidebarNav(currentRoute: currentRoute),

          // Content area - changes with animation
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.02, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile layout with drawer
class _MobileLayout extends StatelessWidget {
  final String currentRoute;
  final Widget child;

  const _MobileLayout({required this.currentRoute, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SidebarNav(currentRoute: currentRoute, isDrawer: true),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.02, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}
