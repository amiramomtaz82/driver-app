import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'geolocator_wrapper.dart';

@Injectable(as: GeolocatorWrapper)
class GeolocatorWrapperImpl implements GeolocatorWrapper {
  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) =>
      Geolocator.getPositionStream(
          locationSettings: locationSettings ?? const LocationSettings());
}
