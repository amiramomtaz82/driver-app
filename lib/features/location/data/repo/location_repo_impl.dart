import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/base_response/safe_call.dart';
import 'package:driver_app/features/location/data/data_source/location_remote_data_source.dart';
import 'package:driver_app/features/location/data/service/gps_location_service.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@Injectable(as: LocationRepo)
class LocationRepoImpl implements LocationRepo {
  final LocationRemoteDataSource _remoteDataSource;
  final GpsLocationService _gpsService;

  LocationRepoImpl(this._remoteDataSource, this._gpsService);

  @override
  Future<BaseResponse<LatLng>> getCurrentLocation() =>
      safeCall(() => _remoteDataSource.getDriverLocation());

  @override
  Future<BaseResponse<RouteData>> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) =>
      safeCall(() async {
        final result = await _remoteDataSource.getRoute(
          origin: origin,
          destination: destination,
        );
        return RouteData(
          points: result.points,
          distanceMeters: result.distanceMeters,
        );
      });

  @override
  Stream<LatLng> watchDriverLocation() => _gpsService.locationStream;

  @override
  Future<void> reportDriverLocation({required LatLng location}) =>
      _remoteDataSource.reportDriverLocation(
        lat: location.latitude,
        lng: location.longitude,
      );
}
