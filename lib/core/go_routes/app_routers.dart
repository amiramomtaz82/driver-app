import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/forget_password/view/forget_password_view.dart';
import '../../features/auth/presentation/login/login_view.dart';
import '../../features/auth/presentation/register/view/register_view.dart';
import '../../features/auth/presentation/register/view/registeration_success_view.dart';
import '../../features/home/presentation/view/home_view.dart';
import '../../features/onboarding/presentation/view/onboarding_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.register,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: AppRoutes.registrationSuccess,
      name: AppRoutes.registrationSuccess,
      builder: (context, state) => const RegistrationSuccessView(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgetPasswordView(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
  ],
);
