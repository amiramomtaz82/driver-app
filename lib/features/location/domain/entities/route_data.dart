import 'package:equatable/equatable.dart';
import 'location_coordinates.dart';

class RouteData extends Equatable {
  final List<LocationCoordinates> points;
  final double distanceMeters;

  const RouteData({
    required this.points,
    required this.distanceMeters,
  });

  String get formattedDistance {
    if (distanceMeters >= 1000) {
      final km = distanceMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toInt()} m';
  }

  @override
  List<Object?> get props => [points, distanceMeters];
}
