import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
class PickupLocationState extends Equatable {
  final LocationInfo pickupInfo;
  final Resource<LatLng> driverLocationResource;
  final Resource<RouteData> routeResource;
  const PickupLocationState({
    required this.pickupInfo,
    this.driverLocationResource = const Resource.initial(),
    this.routeResource = const Resource.initial(),
  });
  PickupLocationState copyWith({
    LocationInfo? pickupInfo,
    Resource<LatLng>? driverLocationResource,
    Resource<RouteData>? routeResource,
  }) {
    return PickupLocationState(
      pickupInfo: pickupInfo ?? this.pickupInfo,
      driverLocationResource:
          driverLocationResource ?? this.driverLocationResource,
      routeResource: routeResource ?? this.routeResource,
    );
  }
  @override
  List<Object?> get props => [
        pickupInfo,
        driverLocationResource,
        routeResource,
      ];
}
