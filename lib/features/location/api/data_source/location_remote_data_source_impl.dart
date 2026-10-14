import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import '../../data/data_source/location_remote_data_source.dart';
import '../../data/models/driver_location_request_dto.dart';
import '../../data/models/route_result.dart';
import '../client/location_client.dart';

@Injectable(as: LocationRemoteDataSource)
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final LocationApiClient _apiClient;
  final Dio _dio;

  LocationRemoteDataSourceImpl(this._apiClient, this._dio);

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
    final url =
        'https://router.project-osrm.org/route/v1/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson';

    final response = await _dio.get(url);

    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    final routes = data['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) {
      throw Exception('No route found');
    }

    final route = routes.first as Map<String, dynamic>;
    final geometry = route['geometry'] as Map<String, dynamic>;
    final rawCoords = geometry['coordinates'] as List<dynamic>;

    final points = rawCoords.map((coord) {
      final pair = coord as List<dynamic>;
      final lon = (pair[0] as num).toDouble();
      final lat = (pair[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();

    final distance = (route['distance'] as num).toDouble();

    return RouteResult(points: points, distanceMeters: distance);
  }
}
