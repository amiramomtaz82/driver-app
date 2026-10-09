import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
@injectable
class GetRouteUseCase {
  final LocationRepo _locationRepo;
  GetRouteUseCase(this._locationRepo);
  Future<BaseResponse<RouteData>> call({
    required LatLng origin,
    required LatLng destination,
  }) =>
      _locationRepo.getRoute(origin: origin, destination: destination);
}
