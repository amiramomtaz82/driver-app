import 'package:geolocator/geolocator.dart';

abstract interface class GeolocatorWrapper {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Stream<Position> getPositionStream({LocationSettings? locationSettings});
}
