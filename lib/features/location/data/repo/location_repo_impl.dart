import 'dart:async';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/base_response/safe_call.dart';
import 'package:driver_app/features/location/data/data_source/location_remote_data_source.dart';
import 'package:driver_app/features/location/data/service/gps_location_service.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@Injectable(as: LocationRepo)
class LocationRepoImpl implements LocationRepo {
  final LocationRemoteDataSource _remoteDataSource;
  final GpsLocationService _gpsService;

  LocationRepoImpl(this._remoteDataSource, this._gpsService);

  @override
  Future<BaseResponse<LocationCoordinates>> getCurrentLocation() =>
      safeCall(() async {
        final latLng = await _remoteDataSource.getDriverLocation();
        return LocationCoordinates(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
        );
      });

  @override
  Future<BaseResponse<RouteData>> getRoute({
    required LocationCoordinates origin,
    required LocationCoordinates destination,
  }) =>
      safeCall(() async {
        final result = await _remoteDataSource.getRoute(
          origin: LatLng(origin.latitude, origin.longitude),
          destination: LatLng(destination.latitude, destination.longitude),
        );
        return RouteData(
          points: result.points
              .map((p) => LocationCoordinates(
                    latitude: p.latitude,
                    longitude: p.longitude,
                  ))
              .toList(),
          distanceMeters: result.distanceMeters,
        );
      });

  @override
  Stream<BaseResponse<LocationCoordinates>> watchDriverLocation() {
    return _gpsService.locationStream.transform(
      StreamTransformer<Position, BaseResponse<LocationCoordinates>>.fromHandlers(
        handleData: (position, sink) {
          sink.add(SuccessResponse(
            LocationCoordinates(
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          ));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(ErrorResponse(
            errMessage: error.toString(),
          ));
        },
      ),
    );
  }

  @override
  Future<BaseResponse<void>> reportDriverLocation({
    required LocationCoordinates location,
  }) =>
      safeCall(() => _remoteDataSource.reportDriverLocation(
            lat: location.latitude,
            lng: location.longitude,
          ));
}
