import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:latlong2/latlong.dart';
abstract interface class LocationRepo {
  Future<BaseResponse<LatLng>> getCurrentLocation();
  Future<BaseResponse<RouteData>> getRoute({
    required LatLng origin,
    required LatLng destination,
  });
}
