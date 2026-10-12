import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

abstract interface class GeolocatorWrapper {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Stream<Position> getPositionStream({LocationSettings? locationSettings});
}

@Injectable(as: GeolocatorWrapper)
class GeolocatorWrapperImpl implements GeolocatorWrapper {
  @override
  Future<bool> isLocationServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) =>
      Geolocator.getPositionStream(locationSettings: locationSettings ?? const LocationSettings());
}
