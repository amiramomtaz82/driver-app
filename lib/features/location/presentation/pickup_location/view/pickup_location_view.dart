import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/mixins/ui_event_handler_mixin.dart';
import 'package:driver_app/core/app_theme/app_colors.dart';
import 'package:driver_app/core/app_theme/text_styles.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/presentation/pickup_location/manager/pickup_location_cubit.dart';
import 'package:driver_app/features/location/presentation/pickup_location/manager/pickup_location_intents.dart';
import 'package:driver_app/features/location/presentation/pickup_location/manager/pickup_location_state.dart';
import 'package:driver_app/features/location/presentation/widgets/location_address_card.dart';
import 'package:driver_app/features/location/presentation/widgets/location_map_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
class PickupLocationView extends StatefulWidget {
  const PickupLocationView({
    super.key,
    required this.pickupInfo,
    required this.userInfo,
  });
  final LocationInfo pickupInfo;
  final LocationInfo userInfo;
  @override
  State<PickupLocationView> createState() => _PickupLocationViewState();
}
class _PickupLocationViewState extends State<PickupLocationView>
    with UiEventMixin<PickupLocationView, PickupLocationState, UiEvent> {
  late final PickupLocationCubit _cubit;
  @override
  PickupLocationCubit get cubit => _cubit;
  @override
  void initState() {
    _cubit = GetIt.I.get<PickupLocationCubit>(param1: widget.pickupInfo);
    super.initState();
    _cubit.onIntent(const LoadPickupLocation());
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
            BlocBuilder<PickupLocationCubit, PickupLocationState>(
              buildWhen: (prev, curr) =>
                  prev.driverLocationResource != curr.driverLocationResource ||
                  prev.routeResource != curr.routeResource,
              builder: (context, state) {
                final driverLoc = state.driverLocationResource.data;
                final routePoints = state.routeResource.data?.points ?? [];
                if (driverLoc == null) {
                  return const _MapPlaceholder();
                }
                return LocationMapSection(
                  driverLocation: driverLoc,
                  destinationLocation: state.pickupInfo.coordinates,
                  destinationLabel: 'Store',
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
            BlocBuilder<PickupLocationCubit, PickupLocationState>(
              buildWhen: (p, c) =>
                  p.driverLocationResource.status !=
                  c.driverLocationResource.status,
              builder: (context, state) {
                if (state.driverLocationResource.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<PickupLocationCubit, PickupLocationState>(
                    buildWhen: (p, c) => p.routeResource != c.routeResource,
                    builder: (context, state) {
                      final distance = state.routeResource.data?.formattedDistance;
                      if (distance == null) return const SizedBox.shrink();
                      return _DistanceBadge(distance: distance);
                    },
                  ),
                  LocationAddressCard(
                    primaryLabel: 'Pickup address',
                    primaryInfo: widget.pickupInfo,
                    secondaryLabel: 'User address',
                    secondaryInfo: widget.userInfo,
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
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();
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
        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
      ),
    );
  }
}
