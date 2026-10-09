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
