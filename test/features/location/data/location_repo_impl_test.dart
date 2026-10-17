import 'dart:async';

import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/data/data_source/location_remote_data_source.dart';
import 'package:driver_app/features/location/data/models/route_result.dart';
import 'package:driver_app/features/location/data/repo/location_repo_impl.dart';
import 'package:driver_app/features/location/data/service/gps_location_service.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements LocationRemoteDataSource {}

class MockGpsLocationService extends Mock implements GpsLocationService {}

Position _createPosition(double lat, double lng) => Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 1.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 1.0,
      headingAccuracy: 1.0,
    );

void main() {
  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
  });

  late MockRemoteDataSource mockDataSource;
  late MockGpsLocationService mockGpsService;
  late LocationRepoImpl repo;
  late StreamController<Position> gpsController;

  setUp(() {
    mockDataSource = MockRemoteDataSource();
    mockGpsService = MockGpsLocationService();
    repo = LocationRepoImpl(mockDataSource, mockGpsService);
    gpsController = StreamController<Position>.broadcast();

    when(() => mockGpsService.locationStream)
        .thenAnswer((_) => gpsController.stream);
  });

  tearDown(() => gpsController.close());

  group('LocationRepoImpl —', () {
    group('watchDriverLocation', () {
      test('returns Stream of BaseResponse LocationCoordinates', () {
        final stream = repo.watchDriverLocation();

        expect(stream, isA<Stream<BaseResponse<LocationCoordinates>>>());
      });

      test('emits success response from GPS service position', () async {
        final pos1 = _createPosition(30.0, 31.0);
        final pos2 = _createPosition(30.1, 31.1);

        final stream = repo.watchDriverLocation();
        final future = stream.take(2).toList();

        gpsController.add(pos1);
        gpsController.add(pos2);

        final results = await future;

        expect(results.length, 2);
        expect(results[0], isA<SuccessResponse<LocationCoordinates>>());
        expect((results[0] as SuccessResponse<LocationCoordinates>).data,
            const LocationCoordinates(latitude: 30.0, longitude: 31.0));
        expect((results[1] as SuccessResponse<LocationCoordinates>).data,
            const LocationCoordinates(latitude: 30.1, longitude: 31.1));
      });

      test('transforms error into ErrorResponse', () async {
        final stream = repo.watchDriverLocation();
        final future = stream.first;

        gpsController.addError(Exception('GPS error'));

        final result = await future;

        expect(result, isA<ErrorResponse<LocationCoordinates>>());
      });
    });

    group('reportDriverLocation', () {
      test('calls the data source with correct lat/lng', () async {
        when(
          () => mockDataSource.reportDriverLocation(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
          ),
        ).thenAnswer((_) async {});

        const location = LocationCoordinates(latitude: 30.0444, longitude: 31.2357);
        final result = await repo.reportDriverLocation(location: location);

        verify(
          () => mockDataSource.reportDriverLocation(
            lat: 30.0444,
            lng: 31.2357,
          ),
        ).called(1);
        expect(result, isA<SuccessResponse<void>>());
      });

      test('returns error when data source throws', () async {
        when(
          () => mockDataSource.reportDriverLocation(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
          ),
        ).thenThrow(Exception('report failed'));

        const location = LocationCoordinates(latitude: 30.0444, longitude: 31.2357);
        final result = await repo.reportDriverLocation(location: location);

        expect(result, isA<ErrorResponse<void>>());
      });
    });

    group('getCurrentLocation', () {
      test('returns success when data source succeeds', () async {
        when(() => mockDataSource.getDriverLocation())
            .thenAnswer((_) async => const LatLng(30.0, 31.0));

        final result = await repo.getCurrentLocation();

        expect(result, isA<SuccessResponse<LocationCoordinates>>());
        expect((result as SuccessResponse<LocationCoordinates>).data,
            const LocationCoordinates(latitude: 30.0, longitude: 31.0));
      });

      test('returns error when data source throws', () async {
        when(() => mockDataSource.getDriverLocation())
            .thenThrow(Exception('network error'));

        final result = await repo.getCurrentLocation();

        expect(result, isA<ErrorResponse<LocationCoordinates>>());
      });
    });

    group('getRoute', () {
      test('returns route data on success', () async {
        const origin = LocationCoordinates(latitude: 30.0, longitude: 31.0);
        const destination = LocationCoordinates(latitude: 30.1, longitude: 31.1);
        when(() => mockDataSource.getRoute(
              origin: any(named: 'origin'),
              destination: any(named: 'destination'),
            )).thenAnswer((_) async => const RouteResult(
              points: [LatLng(30.0, 31.0), LatLng(30.1, 31.1)],
              distanceMeters: 1000,
            ));

        final result =
            await repo.getRoute(origin: origin, destination: destination);

        expect(result, isA<SuccessResponse>());
      });
    });
  });
}
