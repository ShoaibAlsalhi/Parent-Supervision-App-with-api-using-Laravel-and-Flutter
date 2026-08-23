import 'package:go_router/go_router.dart';
import 'package:parent_supervision/presentation/pages/auth/login_page.dart';

import '../../presentation/pages/dashboard/dashboard.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (cointext, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
}