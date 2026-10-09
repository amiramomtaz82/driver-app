import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/mixins/ui_event_handler_mixin.dart';
import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/app_theme/text_styles.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_cubit.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_intents.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';
import 'package:driver_app/features/location/presentation/widgets/location_address_card.dart';
import 'package:driver_app/features/location/presentation/widgets/location_map_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LocationDetailView extends StatefulWidget {
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
  State<LocationDetailView> createState() => _LocationDetailViewState();
}

class _LocationDetailViewState extends State<LocationDetailView>
    with UiEventMixin<LocationDetailView, LocationDetailState, UiEvent> {
  late final LocationDetailCubit _cubit;

  @override
  LocationDetailCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = GetIt.I.get<LocationDetailCubit>(
      param1: LocationDetailState(
        type: widget.type,
        primaryInfo: widget.primaryInfo,
        secondaryInfo: widget.secondaryInfo,
      ),
    );
    super.initState();
    _cubit.onIntent(const LoadLocationDetail());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
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

                if (resource.isError) {
                  return _LocationErrorPlaceholder(
                    message: resource.errorMessage ?? 'Failed to get location',
                    onRetry: () => _cubit.onIntent(const LoadLocationDetail()),
                  );
                }
                if (driverLoc == null) {
                  return const _MapLoadingPlaceholder();
                }
                return LocationMapSection(
                  driverLocation: driverLoc,
                  destinationLocation: state.primaryInfo.coordinates,
                  destinationLabel: state.destinationLabel,
                  routePoints: routePoints,
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
                      final distance = state.routeResource.data?.formattedDistance;
                      if (distance == null) return const SizedBox.shrink();
                      return _DistanceBadge(distance: distance);
                    },
                  ),
                  LocationAddressCard(
                    primaryLabel: _cubit.state.primaryLabel,
                    primaryInfo: widget.primaryInfo,
                    secondaryLabel: _cubit.state.secondaryLabel,
                    secondaryInfo: widget.secondaryInfo,
                  ),
                ],
              ),
            ),
          ],
        ),
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
              'Getting your location...',
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
            const Icon(Icons.location_off, color: AppColors.pink, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: Colors.white,
              ),
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
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.pink.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_car, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            distance,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
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
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.pink,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
