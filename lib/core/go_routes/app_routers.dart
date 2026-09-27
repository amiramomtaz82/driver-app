import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/pickup_location/view/pickup_location_view.dart';
import 'package:driver_app/features/location/presentation/user_location/view/user_location_view.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/forget_password/view/forget_password_view.dart';
import '../../features/auth/presentation/login/login_view.dart';
import '../../features/auth/presentation/register/view/register_view.dart';
import '../../features/auth/presentation/register/view/registeration_success_view.dart';
import '../../features/onboarding/presentation/view/onboarding_view.dart';
class PickupLocationArgs {
  const PickupLocationArgs({
    required this.pickupInfo,
    required this.userInfo,
  });
  final LocationInfo pickupInfo;
  final LocationInfo userInfo;
}
class UserLocationArgs {
  const UserLocationArgs({
    required this.userInfo,
    required this.pickupInfo,
  });
  final LocationInfo userInfo;
  final LocationInfo pickupInfo;
}
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
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
        final args = state.extra! as PickupLocationArgs;
        return PickupLocationView(
          pickupInfo: args.pickupInfo,
          userInfo: args.userInfo,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.userLocation,
      name: AppRoutes.userLocation,
      builder: (context, state) {
        final args = state.extra! as UserLocationArgs;
        return UserLocationView(
          userInfo: args.userInfo,
          pickupInfo: args.pickupInfo,
        );
      },
    ),
  ],
);
