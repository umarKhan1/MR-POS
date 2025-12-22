import 'package:go_router/go_router.dart';
import 'package:mrpos/core/router/route_names.dart';
import 'package:mrpos/features/authentication/presentation/screens/login_screen.dart';

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
      // TODO: Add more routes as features are implemented
    ],
  );
}
