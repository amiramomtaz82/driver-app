import 'dart:async';

import 'package:driver_app/features/location/data/data_source/location_remote_data_source.dart';
import 'package:driver_app/features/location/data/repo/location_repo_impl.dart';
import 'package:driver_app/features/location/data/service/gps_location_service.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements LocationRemoteDataSource {}

class MockGpsLocationService extends Mock implements GpsLocationService {}

void main() {
  late MockRemoteDataSource mockDataSource;
  late MockGpsLocationService mockGpsService;
  late LocationRepoImpl repo;
  late StreamController<LatLng> gpsController;

  setUp(() {
    mockDataSource = MockRemoteDataSource();
    mockGpsService = MockGpsLocationService();
    repo = LocationRepoImpl(mockDataSource, mockGpsService);
    gpsController = StreamController<LatLng>.broadcast();

    when(() => mockGpsService.locationStream)
        .thenAnswer((_) => gpsController.stream);
  });

  tearDown(() => gpsController.close());

  group('LocationRepoImpl —', () {
    group('watchDriverLocation', () {
      test('returns the GPS stream from the service', () {
        final stream = repo.watchDriverLocation();

        expect(stream, isA<Stream<LatLng>>());
      });

      test('emits locations from the GPS service', () async {
        const loc1 = LatLng(30.0, 31.0);
        const loc2 = LatLng(30.1, 31.1);

        final stream = repo.watchDriverLocation();
        final future = stream.take(2).toList();

        gpsController.add(loc1);
        gpsController.add(loc2);

        final results = await future;

        expect(results, [loc1, loc2]);
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

        const location = LatLng(30.0444, 31.2357);
        await repo.reportDriverLocation(location: location);

        verify(
          () => mockDataSource.reportDriverLocation(
            lat: 30.0444,
            lng: 31.2357,
          ),
        ).called(1);
      });
    });

    group('getCurrentLocation', () {
      test('returns success when data source succeeds', () async {
        when(() => mockDataSource.getDriverLocation())
            .thenAnswer((_) async => const LatLng(30.0, 31.0));

        final result = await repo.getCurrentLocation();

        expect(result, isA<SuccessResponse<LatLng>>());
        expect((result as SuccessResponse<LatLng>).data, const LatLng(30.0, 31.0));
      });

      test('returns error when data source throws', () async {
        when(() => mockDataSource.getDriverLocation())
            .thenThrow(Exception('network error'));

        final result = await repo.getCurrentLocation();

        expect(result, isA<ErrorResponse<LatLng>>());
      });
    });
  });
}
