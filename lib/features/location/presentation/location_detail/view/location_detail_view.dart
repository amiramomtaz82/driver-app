import 'package:easy_localization/easy_localization.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/di/di.dart';
import 'package:driver_app/config/mixins/ui_event_handler_mixin.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/app_theme/text_styles.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/location_detail/extensions/location_detail_type_extension.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_cubit.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_intents.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';
import 'package:driver_app/features/location/presentation/widgets/location_address_card.dart';
import 'package:driver_app/features/location/presentation/widgets/location_map_section.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LocationDetailView extends StatelessWidget {
  const LocationDetailView({
    super.key,
    required this.type,
    required this.primaryInfo,
    required this.secondaryInfo,
  });

  const LocationDetailView.pickup({
    super.key,
    required LocationInfo pickupInfo,
    required LocationInfo userInfo,
  })  : type = LocationDetailType.pickup,
        primaryInfo = pickupInfo,
        secondaryInfo = userInfo;

  const LocationDetailView.user({
    super.key,
    required LocationInfo userInfo,
    required LocationInfo pickupInfo,
  })  : type = LocationDetailType.user,
        primaryInfo = userInfo,
        secondaryInfo = pickupInfo;

  final LocationDetailType type;
  final LocationInfo primaryInfo;
  final LocationInfo secondaryInfo;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationDetailCubit>(
        param1: LocationDetailState(
          type: type,
          primaryInfo: primaryInfo,
          secondaryInfo: secondaryInfo,
        ),
      )..onIntent(const LoadLocationDetail()),
      child: _LocationDetailBody(
        type: type,
        primaryInfo: primaryInfo,
        secondaryInfo: secondaryInfo,
      ),
    );
  }
}

class _LocationDetailBody extends StatefulWidget {
  const _LocationDetailBody({
    required this.type,
    required this.primaryInfo,
    required this.secondaryInfo,
  });

  final LocationDetailType type;
  final LocationInfo primaryInfo;
  final LocationInfo secondaryInfo;

  @override
  State<_LocationDetailBody> createState() => _LocationDetailBodyState();
}

class _LocationDetailBodyState extends State<_LocationDetailBody>
    with UiEventMixin<_LocationDetailBody, LocationDetailState, UiEvent> {
  @override
  LocationDetailCubit get cubit => context.read<LocationDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LocationDetailCubit, LocationDetailState>(
            buildWhen: (prev, curr) =>
                prev.driverLocationResource != curr.driverLocationResource ||
                prev.routeResource != curr.routeResource,
            builder: (context, state) {
              final resource = state.driverLocationResource;
              final driverLoc = resource.data;
              final routePoints = state.routeResource.data?.points ?? [];

              if (resource.isLoading || resource.status == ApiStatus.initial) {
                return const _MapLoadingPlaceholder();
              }

              if (resource.isError) {
                return _LocationErrorPlaceholder(
                  message: resource.errorMessage ??
                      LocaleKeys.orders_failed_to_get_location.tr(),
                  onRetry: () => context
                      .read<LocationDetailCubit>()
                      .onIntent(const LoadLocationDetail()),
                );
              }

              if (driverLoc != null) {
                return LocationMapSection(
                  driverLocation: driverLoc,
                  destinationLocation: widget.primaryInfo.coordinates,
                  destinationLabel: widget.type.destinationLabel,
                  routePoints: routePoints,
                );
              }

              return _LocationErrorPlaceholder(
                message: LocaleKeys.orders_failed_to_get_location.tr(),
                onRetry: () => context
                    .read<LocationDetailCubit>()
                    .onIntent(const LoadLocationDetail()),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _BackButton(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<LocationDetailCubit, LocationDetailState>(
                  buildWhen: (p, c) => p.routeResource != c.routeResource,
                  builder: (context, state) {
                    final routeResource = state.routeResource;
                    if (routeResource.isLoading) {
                      return _RouteStatusBadge(
                        text: LocaleKeys.orders_calculating_route.tr(),
                        isLoading: true,
                      );
                    }
                    if (routeResource.isError) {
                      return _RouteStatusBadge(
                        text: LocaleKeys.orders_route_unavailable.tr(),
                        isLoading: false,
                      );
                    }
                    final distance = routeResource.data?.formattedDistance;
                    if (distance != null) {
                      return _DistanceBadge(distance: distance);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                LocationAddressCard(
                  primaryLabel: widget.type.primaryLabel,
                  primaryInfo: widget.primaryInfo,
                  secondaryLabel: widget.type.secondaryLabel,
                  secondaryInfo: widget.secondaryInfo,
                  onIntent: context.read<LocationDetailCubit>().onIntent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapLoadingPlaceholder extends StatelessWidget {
  const _MapLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.pink),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.orders_getting_location.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationErrorPlaceholder extends StatelessWidget {
  const _LocationErrorPlaceholder({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.white,
              ),
              child: Text(LocaleKeys.common_retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  const _DistanceBadge({required this.distance});

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_car, size: 18, color: AppColors.pink),
          const SizedBox(width: 6),
          Text(
            distance,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteStatusBadge extends StatelessWidget {
  const _RouteStatusBadge({
    required this.text,
    required this.isLoading,
  });

  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.pink,
              ),
            )
          else
            const Icon(Icons.info_outline, size: 16, color: AppColors.grey),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.pop(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_back, color: AppColors.black),
        ),
      ),
    );
  }
}
