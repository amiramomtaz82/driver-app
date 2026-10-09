import 'dart:async';

import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class ReportDriverLocationUseCase {
  final LocationRepo _repo;

  static const double _minReportDistanceMeters = 100.0;
  LatLng? _lastReportedLocation;
  StreamSubscription<LatLng>? _subscription;

  ReportDriverLocationUseCase(this._repo);

  void startReporting() {
    _subscription?.cancel();
    _subscription = _repo.watchDriverLocation().listen(
      (currentLocation) async {
        if (_shouldReport(currentLocation)) {
          _lastReportedLocation = currentLocation;
          await _repo.reportDriverLocation(location: currentLocation);
        }
      },
    );
  }

  bool _shouldReport(LatLng current) {
    if (_lastReportedLocation == null) return true;
    final distance = const Distance().as(
      LengthUnit.Meter,
      _lastReportedLocation!,
      current,
    );
    return distance >= _minReportDistanceMeters;
  }

  void stopReporting() {
    _subscription?.cancel();
    _subscription = null;
    _lastReportedLocation = null;
  }
}
