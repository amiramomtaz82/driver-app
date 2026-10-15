import 'package:driver_app/config/di/di.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/location/presentation/location_detail/location_detail_args.dart';
import 'package:driver_app/features/location/presentation/location_detail/view/location_detail_view.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/forget_password/view/forget_password_view.dart';
import '../../features/auth/presentation/login/login_view.dart';
import '../../features/auth/presentation/register/manager/register_cubit.dart';
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
  initialLocation: AppRoutes.pickupLocation,
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
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<RegisterCubit>(),
        child: const RegisterView(),
      ),
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
    GoRoute(
      path: AppRoutes.pickupLocation,
      name: AppRoutes.pickupLocation,
      builder: (context, state) {
        final args = state.extra as LocationDetailArgs?;
        if (args == null) {
          return Scaffold(
            body: Center(
              child: Text(LocaleKeys.orders_missing_location_data.tr()),
            ),
          );
        }
        return LocationDetailView.pickup(
          pickupInfo: args.primaryInfo,
          userInfo: args.secondaryInfo,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.userLocation,
      name: AppRoutes.userLocation,
      builder: (context, state) {
        final args = state.extra as LocationDetailArgs?;
        if (args == null) {
          return Scaffold(
            body: Center(
              child: Text(LocaleKeys.orders_missing_location_data.tr()),
            ),
          );
        }
        return LocationDetailView.user(
          userInfo: args.primaryInfo,
          pickupInfo: args.secondaryInfo,
        );
      },
    ),
  ],
);
