import 'package:latlong2/latlong.dart';
import 'route_result.dart';

class OsrmRouteResponseDto {
  final List<LatLng> points;
  final double distanceMeters;

  const OsrmRouteResponseDto({
    required this.points,
    required this.distanceMeters,
  });

  factory OsrmRouteResponseDto.fromJson(Map<String, dynamic> json) {
    final routes = json['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) {
      return const OsrmRouteResponseDto(points: [], distanceMeters: 0);
    }

    final route = routes.first as Map<String, dynamic>;
    final geometry = route['geometry'] as Map<String, dynamic>?;
    final rawCoords = geometry?['coordinates'] as List<dynamic>? ?? [];

    final points = rawCoords.map((coord) {
      final pair = coord as List<dynamic>;
      final lon = (pair[0] as num).toDouble();
      final lat = (pair[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();

    final distance = (route['distance'] as num?)?.toDouble() ?? 0.0;

    return OsrmRouteResponseDto(
      points: points,
      distanceMeters: distance,
    );
  }

  RouteResult toRouteResult() => RouteResult(
        points: points,
        distanceMeters: distanceMeters,
      );
}
