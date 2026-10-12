import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/data/service/url_launcher_service.dart';
import 'package:driver_app/features/location/domain/entities/location_info.dart';
import 'package:driver_app/features/location/domain/entities/route_data.dart';
import 'package:driver_app/features/location/domain/use_cases/get_route_use_case.dart';
import 'package:driver_app/features/location/domain/use_cases/watch_driver_location_use_case.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_cubit.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_intents.dart';
import 'package:driver_app/features/location/presentation/location_detail/manager/location_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchDriverLocation extends Mock
    implements WatchDriverLocationUseCase {}

class MockGetRoute extends Mock implements GetRouteUseCase {}

class MockUrlLauncherService extends Mock implements UrlLauncherService {}

const _storeCoords = LatLng(30.05, 31.25);

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
    coordinates: LatLng(30.06, 31.26),
  ),
);

const _routeData = RouteData(
  points: [LatLng(30.0, 31.0), _storeCoords],
  distanceMeters: 5500,
);

void main() {
  late MockWatchDriverLocation mockWatch;
  late MockGetRoute mockGetRoute;
  late MockUrlLauncherService mockUrlLauncher;
  late StreamController<LatLng> locationController;

  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
  });

  setUp(() {
    mockWatch = MockWatchDriverLocation();
    mockGetRoute = MockGetRoute();
    mockUrlLauncher = MockUrlLauncherService();
    locationController = StreamController<LatLng>.broadcast();

    when(() => mockWatch.call())
        .thenAnswer((_) => locationController.stream);
  });

  tearDown(() => locationController.close());

  LocationDetailCubit buildCubit() => LocationDetailCubit(
        mockWatch,
        mockGetRoute,
        mockUrlLauncher,
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
        locationController.add(const LatLng(30.0, 31.0));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'driver loading', true)
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
      'updates driver location on subsequent GPS emissions without re-fetching route',
      build: () {
        when(
          () => mockGetRoute(
            origin: any(named: 'origin'),
            destination: any(named: 'destination'),
          ),
        ).thenAnswer((_) async => const SuccessResponse(_routeData));
        return buildCubit();
      },
      act: (cubit) async {
        cubit.onIntent(const LoadLocationDetail());
        locationController.add(const LatLng(30.0, 31.0));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        locationController.add(const LatLng(30.001, 31.001));
      },
      wait: const Duration(milliseconds: 200),
      verify: (_) {
        verify(
          () => mockGetRoute(
            origin: any(named: 'origin'),
            destination: any(named: 'destination'),
          ),
        ).called(1);
      },
    );

    blocTest<LocationDetailCubit, LocationDetailState>(
      'emits error state when GPS stream emits an error',
      build: () => buildCubit(),
      act: (cubit) {
        cubit.onIntent(const LoadLocationDetail());
        locationController.addError(Exception('GPS disabled'));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'loading', true),
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isError, 'driver error', true)
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
        locationController.add(const LatLng(30.0, 31.0));
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
