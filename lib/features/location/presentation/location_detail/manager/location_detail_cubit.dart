import 'dart:async';

import 'package:driver_app/config/base/base_cubit.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/data/service/url_launcher_service.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/use_cases/get_route_use_case.dart';
import 'package:driver_app/features/location/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

import 'location_detail_intents.dart';
import 'location_detail_state.dart';

@injectable
class LocationDetailCubit extends BaseCubit<LocationDetailState, UiEvent> {
  final WatchDriverLocationUseCase _watchDriverLocation;
  final GetRouteUseCase _getRoute;
  final UrlLauncherService _urlLauncher;

  StreamSubscription<LatLng>? _locationSub;
  bool _routeFetched = false;

  LocationDetailCubit(
    this._watchDriverLocation,
    this._getRoute,
    this._urlLauncher,
    @factoryParam LocationDetailState initialState,
  ) : super(initialState);

  void onIntent(LocationDetailIntent intent) {
    switch (intent) {
      case LoadLocationDetail():
        _startWatching();
      case CallTapped(:final phone):
        _call(phone);
      case MessageTapped(:final phone):
        _message(phone);
    }
  }

  Future<void> _call(String phone) async {
    final success = await _urlLauncher.launchPhone(phone);
    if (!success) {
      emitEvent(const ShowSnackBarEvent(
        message: 'Could not make phone call',
        isError: true,
      ));
    }
  }

  Future<void> _message(String phone) async {
    final success = await _urlLauncher.launchSms(phone);
    if (!success) {
      emitEvent(const ShowSnackBarEvent(
        message: 'Could not send message',
        isError: true,
      ));
    }
  }

  void _startWatching() {
    _locationSub?.cancel();
    _routeFetched = false;

    emit(state.copyWith(
      driverLocationResource: const Resource.loading(),
      routeResource: const Resource.loading(),
    ));

    _locationSub = _watchDriverLocation().listen(
      (driverLatLng) {
        emit(state.copyWith(
          driverLocationResource: Resource.success(driverLatLng),
        ));

        if (!_routeFetched) {
          _routeFetched = true;
          _fetchRoute(driverLatLng);
        }
      },
      onError: (Object error) {
        final message = error.toString();
        emit(state.copyWith(
          driverLocationResource: Resource.error(message),
          routeResource: Resource.error(message),
        ));
        emitEvent(ShowSnackBarEvent(message: message, isError: true));
      },
    );
  }

  Future<void> _fetchRoute(LatLng driverLatLng) async {
    final routeResponse = await _getRoute(
      origin: driverLatLng,
      destination: state.primaryInfo.coordinates,
    );

    switch (routeResponse) {
      case SuccessResponse<RouteData> r:
        emit(state.copyWith(routeResource: Resource.success(r.data)));
      case ErrorResponse<RouteData> e:
        emit(state.copyWith(routeResource: Resource.error(e.errMessage)));
        emitEvent(ShowSnackBarEvent(message: e.errMessage, isError: true));
    }
  }

  @override
  Future<void> close() {
    _locationSub?.cancel();
    _locationSub = null;
    return super.close();
  }
}
