import 'package:driver_app/config/base/base_cubit.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/use_cases/get_current_location_use_case.dart';
import 'package:driver_app/features/location/domain/use_cases/get_route_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'user_location_intents.dart';
import 'user_location_state.dart';
@injectable
class UserLocationCubit extends BaseCubit<UserLocationState, UiEvent> {
  final GetCurrentLocationUseCase _getCurrentLocation;
  final GetRouteUseCase _getRoute;
  UserLocationCubit(
    this._getCurrentLocation,
    this._getRoute,
    @factoryParam LocationInfo userInfo,
  ) : super(UserLocationState(userInfo: userInfo));
  void onIntent(UserLocationIntent intent) {
    switch (intent) {
      case LoadUserLocation():
        _load();
      case CallUserTapped():
        break;
      case MessageUserTapped():
        break;
    }
  }
  Future<void> _load() async {
    emit(state.copyWith(
      driverLocationResource: const Resource.loading(),
      routeResource: const Resource.loading(),
    ));
    final locationResponse = await _getCurrentLocation();
    switch (locationResponse) {
      case SuccessResponse<LatLng> s:
        final driverLatLng = s.data;
        emit(state.copyWith(
          driverLocationResource: Resource.success(driverLatLng),
        ));
        final routeResponse = await _getRoute(
          origin: driverLatLng,
          destination: state.userInfo.coordinates,
        );
        switch (routeResponse) {
          case SuccessResponse<RouteData> r:
            emit(state.copyWith(routeResource: Resource.success(r.data)));
          case ErrorResponse<RouteData> e:
            emit(state.copyWith(routeResource: Resource.error(e.errMessage)));
            emitEvent(ShowSnackBarEvent(message: e.errMessage, isError: true));
        }
      case ErrorResponse<LatLng> e:
        emit(state.copyWith(
          driverLocationResource: Resource.error(e.errMessage),
          routeResource: Resource.error(e.errMessage),
        ));
        emitEvent(ShowSnackBarEvent(message: e.errMessage, isError: true));
    }
  }
}
