import 'package:flutter_web/core/routes/app_route_keys.dart';
import 'package:flutter_web/core/routes/navigation_service.dart';
import 'package:flutter_web/features/authentication/presentation/pages/login_page.dart';
import 'package:flutter_web/features/authentication/presentation/pages/register_page.dart';
import 'package:flutter_web/features/chat/presentation/pages/chat_list_page.dart';
import 'package:flutter_web/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_web/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

class RouteUtils {
  var goRouter = GoRouter(
      navigatorKey: NavigationService().navigatorKey,
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
            builder: (context, state) => const LoginPage(),
            name: AppRoutes.login,
            path: AppRoutes.login),
        GoRoute(
            builder: (context, state) => const ChatPage(),
            name: AppRoutes.chat,
            path: AppRoutes.chat),
        GoRoute(
            builder: (context, state) => const ChatListPage(),
            name: AppRoutes.chatList,
            path: AppRoutes.chatList),
        GoRoute(
            builder: (context, state) => RegisterPage(),
            name: AppRoutes.register,
            path: AppRoutes.register),
        GoRoute(
            builder: (context, state) => const HomePage(),
            name: AppRoutes.home,
            path: AppRoutes.home),
      ]);
}
