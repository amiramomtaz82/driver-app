import 'package:latlong2/latlong.dart';
import '../../domain/entities/location_coordinates.dart';

extension LocationCoordinatesX on LocationCoordinates {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension LatLngX on LatLng {
  LocationCoordinates toCoordinates() => LocationCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
}
