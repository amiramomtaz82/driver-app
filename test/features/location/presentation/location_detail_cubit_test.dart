import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
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
  late StreamController<LatLng> locationController;

  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
  });

  setUp(() {
    mockWatch = MockWatchDriverLocation();
    mockGetRoute = MockGetRoute();
    locationController = StreamController<LatLng>.broadcast();

    when(() => mockWatch.call())
        .thenAnswer((_) => locationController.stream);
  });

  tearDown(() => locationController.close());

  LocationDetailCubit buildCubit() =>
      LocationDetailCubit(mockWatch, mockGetRoute, _initialState);

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
        // Loading state
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'driver loading', true)
            .having((s) => s.routeResource.isLoading, 'route loading', true),
        // Driver location success
        isA<LocationDetailState>().having(
          (s) => s.driverLocationResource.isSuccess,
          'driver success',
          true,
        ),
        // Route success
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
        // getRoute should only be called once (on the first emission).
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
        // Loading
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'loading', true),
        // Error
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
        // Loading
        isA<LocationDetailState>()
            .having((s) => s.driverLocationResource.isLoading, 'loading', true),
        // Driver location success
        isA<LocationDetailState>().having(
          (s) => s.driverLocationResource.isSuccess,
          'driver success',
          true,
        ),
        // Route error
        isA<LocationDetailState>().having(
          (s) => s.routeResource.isError,
          'route error',
          true,
        ),
      ],
    );
  });
}
