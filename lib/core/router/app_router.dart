import 'package:go_router/go_router.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/features/authentication/presentation/screens/login_screen.dart';
import 'package:mrpos/features/dashboard/presentation/screens/dashboard_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
