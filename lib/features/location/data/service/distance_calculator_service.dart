import '../../domain/entities/location_coordinates.dart';

abstract interface class DistanceCalculatorService {
  double calculateDistanceInMeters(
    LocationCoordinates from,
    LocationCoordinates to,
  );
}
