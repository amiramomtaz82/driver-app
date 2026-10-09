import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';
import 'package:driver_app/features/location/presentation/location_detail/view/location_detail_view.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' as latlong2;
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

class LocationDetailArgs {
  const LocationDetailArgs({
    required this.type,
    required this.primaryInfo,
    required this.secondaryInfo,
  });
  final LocationDetailType type;
  final LocationInfo primaryInfo;
  final LocationInfo secondaryInfo;
}

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
      path: AppRoutes.pickupLocation,
      name: AppRoutes.pickupLocation,
      builder: (context, state) {
        final args = state.extra as LocationDetailArgs? ??
            LocationDetailArgs(
              type: LocationDetailType.pickup,
              primaryInfo: LocationInfo(
                name: 'Flowery store',
                address: '20th st, Sheikh Zayed, Giza',
                coordinates: latlong2.LatLng(30.0131, 31.2089),
              ),
              secondaryInfo: LocationInfo(
                name: 'Nour mohamed',
                address: '20th st, Sheikh Zayed, Giza',
                coordinates: latlong2.LatLng(30.0444, 31.2357),
              ),
            );
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
        final args = state.extra as LocationDetailArgs? ??
            LocationDetailArgs(
              type: LocationDetailType.user,
              primaryInfo: LocationInfo(
                name: 'Nour mohamed',
                address: '20th st, Sheikh Zayed, Giza',
                coordinates: latlong2.LatLng(30.0444, 31.2357),
              ),
              secondaryInfo: LocationInfo(
                name: 'Flowery store',
                address: '20th st, Sheikh Zayed, Giza',
                coordinates: latlong2.LatLng(30.0131, 31.2089),
              ),
            );
        return LocationDetailView.user(
          userInfo: args.primaryInfo,
          pickupInfo: args.secondaryInfo,
        );
      },
    ),
  ],
);
