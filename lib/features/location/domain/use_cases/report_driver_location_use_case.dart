import 'dart:async';

import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/data/service/distance_calculator_service.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReportDriverLocationUseCase {
  final LocationRepo _repo;
  final DistanceCalculatorService _distanceCalculator;

  static const double _minReportDistanceMeters = 100.0;
  LocationCoordinates? _lastReportedLocation;
  StreamSubscription<BaseResponse<LocationCoordinates>>? _subscription;

  ReportDriverLocationUseCase(this._repo, this._distanceCalculator);

  void startReporting() {
    _subscription?.cancel();
    _subscription = _repo.watchDriverLocation().listen(
      (response) async {
        if (response is SuccessResponse<LocationCoordinates>) {
          final currentLocation = response.data;
          if (_shouldReport(currentLocation)) {
            _lastReportedLocation = currentLocation;
            await _repo.reportDriverLocation(location: currentLocation);
          }
        }
      },
    );
  }

  bool _shouldReport(LocationCoordinates current) {
    if (_lastReportedLocation == null) return true;
    final distance = _distanceCalculator.calculateDistanceInMeters(
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
