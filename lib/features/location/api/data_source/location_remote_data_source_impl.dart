import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import '../../data/data_source/location_remote_data_source.dart';
import '../../data/models/driver_location_request_dto.dart';
import '../../data/models/route_result.dart';
import '../client/location_client.dart';

@Injectable(as: LocationRemoteDataSource)
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final LocationApiClient _apiClient;

  LocationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LatLng> getDriverLocation() async {
    final response = await _apiClient.getDriverLocation();
    return LatLng(response.lat, response.lng);
  }

  @override
  Future<void> reportDriverLocation({
    required double lat,
    required double lng,
  }) async {
    await _apiClient.reportDriverLocation(
      DriverLocationRequestDto.create(lat: lat, lng: lng),
    );
  }

  @override
  Future<RouteResult> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final coordinates =
        '${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}';
    final response = await _apiClient.getRoute(coordinates);
    return response.toRouteResult();
  }
}
