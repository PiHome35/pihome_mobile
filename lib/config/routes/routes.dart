import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/login_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/register_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/splash_page.dart';
import 'package:mobile_pihome/success_login.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const success = '/success';

  static final router = GoRouter(
    initialLocation: splash,
    routes: <RouteBase>[
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: success,
        builder: (context, state) => const LoginSuccess(),
      ),
    ],
  );
}
