import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:equatable/equatable.dart';

enum LocationDetailType { pickup, user }

class LocationDetailState extends Equatable {
  final LocationDetailType type;
  final LocationInfo primaryInfo;
  final LocationInfo secondaryInfo;
  final Resource<LocationCoordinates> driverLocationResource;
  final Resource<RouteData> routeResource;

  const LocationDetailState({
    required this.type,
    required this.primaryInfo,
    required this.secondaryInfo,
    this.driverLocationResource = const Resource.initial(),
    this.routeResource = const Resource.initial(),
  });

  LocationDetailState copyWith({
    Resource<LocationCoordinates>? driverLocationResource,
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
