import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/data/service/distance_calculator_service.dart';
import 'package:driver_app/features/location/data/service/url_launcher_service.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/use_cases/get_route_use_case.dart';
import 'package:driver_app/features/location/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_cubit.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_intents.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchDriverLocation extends Mock
    implements WatchDriverLocationUseCase {}

class MockGetRoute extends Mock implements GetRouteUseCase {}

class MockUrlLauncherService extends Mock implements UrlLauncherService {}

class MockDistanceCalculatorService extends Mock
    implements DistanceCalculatorService {}

const _storeCoords = LocationCoordinates(latitude: 30.05, longitude: 31.25);

const _initialState = LocationDetailState(
  type: LocationDetailType.pickup,
  primaryInfo: LocationInfo(
    name: 'Store',
    address: '123 Main St',
    coordinates: _storeCoords,
  ),
  secondaryInfo: LocationInfo(
    name: 'User',
    address: '456 Side St',
    coordinates: LocationCoordinates(latitude: 30.06, longitude: 31.26),
  ),
);

const _routeData = RouteData(
  points: [LocationCoordinates(latitude: 30.0, longitude: 31.0), _storeCoords],
  distanceMeters: 5500,
);

void main() {
  late MockWatchDriverLocation mockWatch;
  late MockGetRoute mockGetRoute;
  late MockUrlLauncherService mockUrlLauncher;
  late MockDistanceCalculatorService mockDistanceCalculator;
  late StreamController<BaseResponse<LocationCoordinates>> locationController;

  setUpAll(() {
    registerFallbackValue(
        const LocationCoordinates(latitude: 0, longitude: 0));
  });

  setUp(() {
    mockWatch = MockWatchDriverLocation();
    mockGetRoute = MockGetRoute();
    mockUrlLauncher = MockUrlLauncherService();
    mockDistanceCalculator = MockDistanceCalculatorService();
    locationController =
        StreamController<BaseResponse<LocationCoordinates>>.broadcast();

    when(() => mockWatch.call())
        .thenAnswer((_) => locationController.stream);
  });

  tearDown(() => locationController.close());

  LocationDetailCubit buildCubit() => LocationDetailCubit(
        mockWatch,
        mockGetRoute,
        mockUrlLauncher,
        mockDistanceCalculator,
        _initialState,
      );

  group('LocationDetailCubit —', () {
    test('initial state is correct', () {
      final cubit = buildCubit();
      expect(cubit.state, _initialState);
      cubit.close();
    });

    blocTest<LocationDetailCubit, LocationDetailState>(
      'emits loading, then success with driver location on first GPS emission',
      build: () {
        when(
          () => mockGetRoute(
            origin: any(named: 'origin'),
            destination: any(named: 'destination'),
          ),
        ).thenAnswer((_) async => const SuccessResponse(_routeData));
        return buildCubit();
      },
      act: (cubit) {
        cubit.onIntent(const LoadLocationDetail());
        locationController.add(const SuccessResponse(
            LocationCoordinates(latitude: 30.0, longitude: 31.0)));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'driver loading',
                true)
            .having((s) => s.routeResource.isLoading, 'route loading', true),
        isA<LocationDetailState>().having(
          (s) => s.driverLocationResource.isSuccess,
          'driver success',
          true,
        ),
        isA<LocationDetailState>()
            .having((s) => s.routeResource.isSuccess, 'route success', true)
            .having((s) => s.routeResource.data, 'route data', _routeData),
      ],
    );

    blocTest<LocationDetailCubit, LocationDetailState>(
      'updates driver location and re-fetches route when distance moved exceeds threshold',
      build: () {
        when(
          () => mockGetRoute(
            origin: any(named: 'origin'),
            destination: any(named: 'destination'),
          ),
        ).thenAnswer((_) async => const SuccessResponse(_routeData));
        when(() => mockDistanceCalculator.calculateDistanceInMeters(
              any(),
              any(),
            )).thenReturn(60.0);
        return buildCubit();
      },
      act: (cubit) async {
        cubit.onIntent(const LoadLocationDetail());
        locationController.add(const SuccessResponse(
            LocationCoordinates(latitude: 30.0, longitude: 31.0)));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        locationController.add(const SuccessResponse(
            LocationCoordinates(latitude: 30.001, longitude: 31.001)));
      },
      wait: const Duration(milliseconds: 200),
      verify: (_) {
        verify(
          () => mockGetRoute(
            origin: any(named: 'origin'),
            destination: any(named: 'destination'),
          ),
        ).called(2);
      },
    );

    blocTest<LocationDetailCubit, LocationDetailState>(
      'emits error state when GPS stream emits an error',
      build: () => buildCubit(),
      act: (cubit) {
        cubit.onIntent(const LoadLocationDetail());
        locationController.add(ErrorResponse(errMessage: 'GPS disabled'));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'loading', true),
        isA<LocationDetailState>()
            .having(
                (s) => s.driverLocationResource.isError, 'driver error', true)
            .having((s) => s.routeResource.isError, 'route error', true),
      ],
    );

    blocTest<LocationDetailCubit, LocationDetailState>(
      'emits route error when getRoute fails',
      build: () {
        when(
          () => mockGetRoute(
            origin: any(named: 'origin'),
            destination: any(named: 'destination'),
          ),
        ).thenAnswer(
          (_) async => ErrorResponse<RouteData>(errMessage: 'No route'),
        );
        return buildCubit();
      },
      act: (cubit) {
        cubit.onIntent(const LoadLocationDetail());
        locationController.add(const SuccessResponse(
            LocationCoordinates(latitude: 30.0, longitude: 31.0)));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'loading', true),
        isA<LocationDetailState>().having(
          (s) => s.driverLocationResource.isSuccess,
          'driver success',
          true,
        ),
        isA<LocationDetailState>().having(
          (s) => s.routeResource.isError,
          'route error',
          true,
        ),
      ],
    );

    test('calls url launcher on CallTapped intent', () async {
      when(() => mockUrlLauncher.launchPhone('123456'))
          .thenAnswer((_) async => true);
      final cubit = buildCubit();

      cubit.onIntent(const CallTapped(phone: '123456'));
      await Future<void>.delayed(Duration.zero);

      verify(() => mockUrlLauncher.launchPhone('123456')).called(1);
      cubit.close();
    });

    test('calls url launcher on MessageTapped intent', () async {
      when(() => mockUrlLauncher.launchSms('123456'))
          .thenAnswer((_) async => true);
      final cubit = buildCubit();

      cubit.onIntent(const MessageTapped(phone: '123456'));
      await Future<void>.delayed(Duration.zero);

      verify(() => mockUrlLauncher.launchSms('123456')).called(1);
      cubit.close();
    });

    test('emits snackbar event when launchPhone fails', () async {
      when(() => mockUrlLauncher.launchPhone('123456'))
          .thenAnswer((_) async => false);
      final cubit = buildCubit();

      final events = <UiEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      cubit.onIntent(const CallTapped(phone: '123456'));
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      expect(events.first, isA<ShowSnackBarEvent>());
      await sub.cancel();
      cubit.close();
    });

    test('emits snackbar event when launchSms fails', () async {
      when(() => mockUrlLauncher.launchSms('123456'))
          .thenAnswer((_) async => false);
      final cubit = buildCubit();

      final events = <UiEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      cubit.onIntent(const MessageTapped(phone: '123456'));
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      expect(events.first, isA<ShowSnackBarEvent>());
      await sub.cancel();
      cubit.close();
    });
  });
}
