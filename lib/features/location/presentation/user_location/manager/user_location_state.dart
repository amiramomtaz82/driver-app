import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
class UserLocationState extends Equatable {
  final LocationInfo userInfo;
  final Resource<LatLng> driverLocationResource;
  final Resource<RouteData> routeResource;
  const UserLocationState({
    required this.userInfo,
    this.driverLocationResource = const Resource.initial(),
    this.routeResource = const Resource.initial(),
  });
  UserLocationState copyWith({
    LocationInfo? userInfo,
    Resource<LatLng>? driverLocationResource,
    Resource<RouteData>? routeResource,
  }) {
    return UserLocationState(
      userInfo: userInfo ?? this.userInfo,
      driverLocationResource:
          driverLocationResource ?? this.driverLocationResource,
      routeResource: routeResource ?? this.routeResource,
    );
  }
  @override
  List<Object?> get props => [
        userInfo,
        driverLocationResource,
        routeResource,
      ];
}
