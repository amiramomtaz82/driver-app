import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import '../../data/data_source/location_remote_data_source.dart';
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
    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    final lat = (data['lat'] ?? data['latitude'] as num?)?.toDouble();
    final lng = (data['lng'] ?? data['longitude'] ?? data['lon'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      throw Exception('Invalid location response: $data');
    }
    return LatLng(lat, lng);
  }

  @override
  Future<void> reportDriverLocation({
    required double lat,
    required double lng,
  }) async {
    await _apiClient.reportDriverLocation({
      'lat': lat,
      'lng': lng,
      'recordedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<RouteResult> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson';
    final response = await _dio.get<String>(url);
    final json = jsonDecode(response.data!) as Map<String, dynamic>;
    final routes = json['routes'] as List<dynamic>;
    if (routes.isEmpty) throw Exception('No route found');
    final route = routes[0] as Map<String, dynamic>;
    final distanceMeters = (route['distance'] as num).toDouble();
    final geometry = route['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;
    final points = coordinates.map((c) {
      final pair = c as List<dynamic>;
      return LatLng(
        (pair[1] as num).toDouble(),
        (pair[0] as num).toDouble(),
      );
    }).toList();
    return RouteResult(points: points, distanceMeters: distanceMeters);
  }
}
