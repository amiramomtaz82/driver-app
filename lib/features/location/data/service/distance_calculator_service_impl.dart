import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/location_coordinates.dart';
import 'distance_calculator_service.dart';

@Injectable(as: DistanceCalculatorService)
class DistanceCalculatorServiceImpl implements DistanceCalculatorService {
  final Distance _distance = const Distance();

  @override
  double calculateDistanceInMeters(
    LocationCoordinates from,
    LocationCoordinates to,
  ) {
    return _distance.as(
      LengthUnit.Meter,
      LatLng(from.latitude, from.longitude),
      LatLng(to.latitude, to.longitude),
    );
  }
}
