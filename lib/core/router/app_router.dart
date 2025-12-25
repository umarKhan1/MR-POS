import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/features/authentication/presentation/screens/login_screen.dart';
import 'package:mrpos/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:mrpos/features/menu/presentation/screens/menu_screen.dart';
import 'package:mrpos/features/orders/presentation/screens/orders_screen.dart';
import 'package:mrpos/features/orders/presentation/screens/create_order_screen.dart';
import 'package:mrpos/shared/layouts/main_layout.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      // Login route (no sidebar)
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Shell route with persistent sidebar
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.menu,
            name: RouteNames.menu,
            builder: (context, state) => const MenuScreen(),
          ),
          GoRoute(
            path: RouteNames.orderTable,
            name: RouteNames.orderTable,
            builder: (context, state) => const OrdersScreen(),
          ),
        ],
      ),

      // Create Order route (full screen, no sidebar)
      GoRoute(
        path: RouteNames.createOrder,
        name: RouteNames.createOrder,
        builder: (context, state) {
          final orderId = state.uri.queryParameters['orderId'];
          return CreateOrderScreen(orderId: orderId);
        },
      ),
    ],
  );
}
