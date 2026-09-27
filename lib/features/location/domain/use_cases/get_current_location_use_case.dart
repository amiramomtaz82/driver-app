import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
@injectable
class GetCurrentLocationUseCase {
  final LocationRepo _locationRepo;
  GetCurrentLocationUseCase(this._locationRepo);
  Future<BaseResponse<LatLng>> call() => _locationRepo.getCurrentLocation();
}
