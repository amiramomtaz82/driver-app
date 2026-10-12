import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'geolocator_wrapper.dart';

@lazySingleton
class GpsLocationService {
  final GeolocatorWrapper _geolocator;

  GpsLocationService(this._geolocator);

  StreamController<LatLng>? _controller;
  StreamSubscription<Position>? _positionSub;

  Stream<LatLng> get locationStream {
    _controller ??= StreamController<LatLng>.broadcast(
      onListen: _onListen,
      onCancel: _stopIfNoListeners,
    );
    return _controller!.stream;
  }

  void _onListen() {
    _startListening();
  }

  Future<void> _startListening() async {
    if (_positionSub != null) return;

    final controller = _controller;
    if (controller == null) return;

    try {
      await _ensurePermissions();
    } catch (e) {
      controller.addError(e);
      return;
    }

    if (_controller == null || _controller != controller) return;

    _positionSub = _geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (position) {
        _controller?.add(LatLng(position.latitude, position.longitude));
      },
      onError: (Object error) {
        _controller?.addError(error);
      },
    );
  }

  Future<void> _ensurePermissions() async {
    final serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    var permission = await _geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. Please enable it from Settings.',
      );
    }
  }

  void _stopIfNoListeners() {
    if (_controller != null && !_controller!.hasListener) {
      _positionSub?.cancel();
      _positionSub = null;
      _controller?.close();
      _controller = null;
    }
  }

  @disposeMethod
  void dispose() {
    _positionSub?.cancel();
    _positionSub = null;
    _controller?.close();
    _controller = null;
  }
}
