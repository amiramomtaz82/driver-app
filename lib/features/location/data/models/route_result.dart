import 'package:latlong2/latlong.dart';

class RouteResult {
  const RouteResult({required this.points, required this.distanceMeters});
  final List<LatLng> points;
  final double distanceMeters;
}
