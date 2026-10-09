import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@lazySingleton
class GpsLocationService {
  StreamController<LatLng>? _controller;
  StreamSubscription<Position>? _positionSub;

  Stream<LatLng> get locationStream {
    _controller ??= StreamController<LatLng>.broadcast(
      onListen: _startListening,
      onCancel: _stopIfNoListeners,
    );
    return _controller!.stream;
  }

  Future<void> _startListening() async {
    if (_positionSub != null) return;

    try {
      await _ensurePermissions();
    } catch (e) {
      _controller?.addError(e);
      return;
    }

    _positionSub = Geolocator.getPositionStream(
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
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable GPS.',
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied. '
        'Please enable it from Settings.',
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
