import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'geolocator_wrapper.dart';

@lazySingleton
class GpsLocationService {
  final GeolocatorWrapper _geolocator;

  GpsLocationService(this._geolocator);

  StreamController<Position>? _controller;
  StreamSubscription<Position>? _positionSub;

  Stream<Position> get locationStream {
    _controller ??= StreamController<Position>.broadcast(
      onListen: _onListen,
      onCancel: _stopIfNoListeners,
    );
    if (_positionSub == null) {
      startListening();
    }
    return _controller!.stream;
  }

  void _onListen() {
    startListening();
  }

  Future<void> startListening() async {
    if (_positionSub != null) return;

    final controller = _controller;
    if (controller == null || controller.isClosed) return;

    try {
      await _ensurePermissions();
    } catch (e) {
      if (_controller != null && !_controller!.isClosed) {
        _controller!.addError(e);
      }
      return;
    }

    if (_controller == null || _controller != controller || _controller!.isClosed) return;
    if (_positionSub != null) return;

    _positionSub = _geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      (position) {
        if (_controller != null && !_controller!.isClosed) {
          _controller!.add(position);
        }
      },
      onError: (Object error) {
        if (_controller != null && !_controller!.isClosed) {
          _controller!.addError(error);
        }
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
