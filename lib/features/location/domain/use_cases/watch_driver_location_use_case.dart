import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class WatchDriverLocationUseCase {
  final LocationRepo _repo;

  WatchDriverLocationUseCase(this._repo);

  Stream<LatLng> call() => _repo.watchDriverLocation();
}
