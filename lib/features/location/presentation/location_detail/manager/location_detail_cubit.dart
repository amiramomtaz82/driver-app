import 'dart:async';

import 'package:driver_app/config/base/base_cubit.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/location/data/service/distance_calculator_service.dart';
import 'package:driver_app/features/location/data/service/url_launcher_service.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/use_cases/get_route_use_case.dart';
import 'package:driver_app/features/location/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:driver_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import 'location_detail_intents.dart';
import 'location_detail_state.dart';

@injectable
class LocationDetailCubit extends BaseCubit<LocationDetailState, UiEvent> {
  final WatchDriverLocationUseCase _watchDriverLocation;
  final GetRouteUseCase _getRoute;
  final UrlLauncherService _urlLauncher;
  final DistanceCalculatorService _distanceCalculator;

  StreamSubscription<BaseResponse<LocationCoordinates>>? _locationSub;
  LocationCoordinates? _lastRouteLocation;
  bool _isFetchingRoute = false;

  static const double _minRouteThrottleDistanceMeters = 50.0;

  LocationDetailCubit(
    this._watchDriverLocation,
    this._getRoute,
    this._urlLauncher,
    this._distanceCalculator,
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
      emitEvent(ShowSnackBarEvent(
        message: LocaleKeys.orders_could_not_make_phone_call.tr(),
        isError: true,
      ));
    }
  }

  Future<void> _message(String phone) async {
    final success = await _urlLauncher.launchSms(phone);
    if (!success) {
      emitEvent(ShowSnackBarEvent(
        message: LocaleKeys.orders_could_not_send_message.tr(),
        isError: true,
      ));
    }
  }

  void _startWatching() {
    _locationSub?.cancel();
    _lastRouteLocation = null;

    emit(state.copyWith(
      driverLocationResource: const Resource.loading(),
      routeResource: const Resource.loading(),
    ));

    _locationSub = _watchDriverLocation().listen(
      (response) {
        switch (response) {
          case SuccessResponse<LocationCoordinates> s:
            final driverCoords = s.data;
            emit(state.copyWith(
              driverLocationResource: Resource.success(driverCoords),
            ));
            _checkAndFetchRoute(driverCoords);
          case ErrorResponse<LocationCoordinates> e:
            emit(state.copyWith(
              driverLocationResource: Resource.error(e.errMessage),
              routeResource: Resource.error(e.errMessage),
            ));
            emitEvent(ShowSnackBarEvent(message: e.errMessage, isError: true));
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

  void _checkAndFetchRoute(LocationCoordinates driverCoords) {
    if (_isFetchingRoute) return;

    if (_lastRouteLocation == null) {
      _lastRouteLocation = driverCoords;
      _fetchRoute(driverCoords);
      return;
    }

    final distanceMoved = _distanceCalculator.calculateDistanceInMeters(
      _lastRouteLocation!,
      driverCoords,
    );

    if (distanceMoved >= _minRouteThrottleDistanceMeters) {
      _lastRouteLocation = driverCoords;
      _fetchRoute(driverCoords);
    }
  }

  Future<void> _fetchRoute(LocationCoordinates driverCoords) async {
    _isFetchingRoute = true;
    final routeResponse = await _getRoute(
      origin: driverCoords,
      destination: state.primaryInfo.coordinates,
    );
    _isFetchingRoute = false;

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
