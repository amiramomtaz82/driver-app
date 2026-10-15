import 'package:driver_app/config/base_response/base_response.dart';
import '../entities/location_coordinates.dart';
import '../entities/route_data.dart';

abstract interface class LocationRepo {
  Future<BaseResponse<LocationCoordinates>> getCurrentLocation();

  Future<BaseResponse<RouteData>> getRoute({
    required LocationCoordinates origin,
    required LocationCoordinates destination,
  });

  Stream<BaseResponse<LocationCoordinates>> watchDriverLocation();

  Future<BaseResponse<void>> reportDriverLocation({
    required LocationCoordinates location,
  });
}
