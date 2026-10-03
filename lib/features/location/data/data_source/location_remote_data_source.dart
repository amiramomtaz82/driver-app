import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:driver_app/core/constants/endpoints.dart';

class RouteResult {
  const RouteResult({required this.points, required this.distanceMeters});
  final List<LatLng> points;
  final double distanceMeters;
}

@injectable
class LocationRemoteDataSource {
  final Dio _dio;
  LocationRemoteDataSource(this._dio);

  Future<LatLng> getDriverLocation() async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.driverLocation,
    );
    final data = response.data!;
    final lat = (data['lat'] ?? data['latitude'] as num?)?.toDouble();
    final lng = (data['lng'] ?? data['longitude'] ?? data['lon'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      throw Exception('Invalid location response: $data');
    }
    return LatLng(lat, lng);
  }

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
