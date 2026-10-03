import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config/di/di.dart';
import '../../features/auth/presentation/forget_password/view/forget_password_view.dart';
import '../../features/auth/presentation/login/login_view.dart';
import '../../features/auth/presentation/register/view/register_view.dart';
import '../../features/auth/presentation/register/view/registeration_success_view.dart';
import '../../features/onboarding/presentation/view/onboarding_view.dart';
import '../../features/orders/presentation/home/manager/home_cubit.dart';
import '../../features/orders/presentation/home/view/home_view.dart';
import '../../features/orders/presentation/order_details/manager/order_details_cubit.dart';
import '../../features/orders/presentation/order_details/view/order_details_view.dart';
import '../../features/orders/presentation/order_success/view/order_success_view.dart';
import '../../features/splash/presentation/manager/splash_cubit.dart';
import '../../features/splash/presentation/view/splash_view.dart';
import '../widgets/coming_soon_view.dart';
import 'main_shell_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<SplashCubit>(),
        child: const SplashView(),
      ),
    ),
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellView(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: AppRoutes.home,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<HomeCubit>(),
                child: const HomeView(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.orders,
              name: AppRoutes.orders,
              builder: (context, state) =>
                  const ComingSoonView(title: 'Orders'),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: AppRoutes.profile,
              builder: (context, state) =>
                  const ComingSoonView(title: 'Profile'),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      name: AppRoutes.orderDetails,
      builder: (context, state) {
        final orderId = state.extra as String? ?? '';
        return BlocProvider(
          create: (_) => getIt<OrderDetailsCubit>(param1: orderId),
          child: const OrderDetailsView(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.orderSuccess,
      name: AppRoutes.orderSuccess,
      builder: (context, state) => const OrderSuccessView(),
    ),
  ],
);
