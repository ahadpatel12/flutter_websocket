import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/features/authentication/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

class RouteUtils {
  var goRouter = GoRouter(
      navigatorKey: NavigationService().navigatorKey,
      initialLocation: AppRoutes.login,
      routes: [
        GoRoute(
            builder: (context, state) => const LoginPage(),
            name: AppRoutes.login,
            path: AppRoutes.login),
      ]);
}
