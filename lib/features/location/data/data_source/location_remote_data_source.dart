import 'package:latlong2/latlong.dart';
import '../models/route_result.dart';

abstract interface class LocationRemoteDataSource {
  Future<LatLng> getDriverLocation();
  Future<void> reportDriverLocation({required double lat, required double lng});
  Future<RouteResult> getRoute({required LatLng origin, required LatLng destination});
}
