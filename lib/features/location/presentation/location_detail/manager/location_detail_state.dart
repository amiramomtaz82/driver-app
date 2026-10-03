import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

enum LocationDetailType { pickup, user }

class LocationDetailState extends Equatable {
  final LocationDetailType type;
  final LocationInfo primaryInfo;
  final LocationInfo secondaryInfo;
  final Resource<LatLng> driverLocationResource;
  final Resource<RouteData> routeResource;

  const LocationDetailState({
    required this.type,
    required this.primaryInfo,
    required this.secondaryInfo,
    this.driverLocationResource = const Resource.initial(),
    this.routeResource = const Resource.initial(),
  });

  String get primaryLabel =>
      type == LocationDetailType.pickup ? 'Pickup address' : 'User address';

  String get secondaryLabel =>
      type == LocationDetailType.pickup ? 'User address' : 'Pickup address';

  String get destinationLabel =>
      type == LocationDetailType.pickup ? 'Store' : 'User';

  LocationDetailState copyWith({
    Resource<LatLng>? driverLocationResource,
    Resource<RouteData>? routeResource,
  }) {
    return LocationDetailState(
      type: type,
      primaryInfo: primaryInfo,
      secondaryInfo: secondaryInfo,
      driverLocationResource:
          driverLocationResource ?? this.driverLocationResource,
      routeResource: routeResource ?? this.routeResource,
    );
  }

  @override
  List<Object?> get props => [
        type,
        primaryInfo,
        secondaryInfo,
        driverLocationResource,
        routeResource,
      ];
}
