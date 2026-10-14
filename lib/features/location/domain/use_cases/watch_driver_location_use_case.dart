import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchDriverLocationUseCase {
  final LocationRepo _repo;

  WatchDriverLocationUseCase(this._repo);

  Stream<BaseResponse<LocationCoordinates>> call() =>
      _repo.watchDriverLocation();
}
