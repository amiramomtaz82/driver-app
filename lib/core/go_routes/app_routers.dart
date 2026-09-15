import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login/login_view.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
  GoRoute(
  path: AppRoutes.login,
  name: AppRoutes.login,
  builder: (context, state) => const LoginView(),
),
]
);
