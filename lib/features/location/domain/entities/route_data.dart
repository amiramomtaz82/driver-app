import 'package:latlong2/latlong.dart';
class RouteData {
  const RouteData({required this.points, required this.distanceMeters});
  final List<LatLng> points;
  final double distanceMeters;
  String get formattedDistance {
    if (distanceMeters >= 1000) {
      final km = distanceMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toInt()} m';
  }
}
