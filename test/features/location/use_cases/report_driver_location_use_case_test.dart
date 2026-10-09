import 'dart:async';

import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:driver_app/features/location/domain/use_cases/report_driver_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepo extends Mock implements LocationRepo {}

void main() {
  late MockLocationRepo mockRepo;
  late ReportDriverLocationUseCase useCase;
  late StreamController<LatLng> locationController;

  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
  });

  setUp(() {
    mockRepo = MockLocationRepo();
    useCase = ReportDriverLocationUseCase(mockRepo);
    locationController = StreamController<LatLng>.broadcast();

    when(() => mockRepo.watchDriverLocation())
        .thenAnswer((_) => locationController.stream);
    when(() => mockRepo.reportDriverLocation(location: any(named: 'location')))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    useCase.stopReporting();
    locationController.close();
  });

  group('ReportDriverLocationUseCase —', () {
    test('reports the first location immediately', () async {
      const firstLocation = LatLng(30.0, 31.0);

      useCase.startReporting();
      locationController.add(firstLocation);

      // Allow the stream listener to process.
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockRepo.reportDriverLocation(location: firstLocation),
      ).called(1);
    });

    test('does NOT report when distance < 100 m', () async {
      const origin = LatLng(30.0, 31.0);
      // ~10 m away — should be skipped.
      const nearby = LatLng(30.00009, 31.0);

      useCase.startReporting();
      locationController.add(origin);
      await Future<void>.delayed(Duration.zero);

      // Reset so we only track the second call.
      clearInteractions(mockRepo);
      when(() => mockRepo.reportDriverLocation(location: any(named: 'location')))
          .thenAnswer((_) async {});

      locationController.add(nearby);
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => mockRepo.reportDriverLocation(location: any(named: 'location')),
      );
    });

    test('reports when distance >= 100 m', () async {
      const origin = LatLng(30.0, 31.0);
      // ~1.1 km away — should be reported.
      const farAway = LatLng(30.01, 31.0);

      useCase.startReporting();
      locationController.add(origin);
      await Future<void>.delayed(Duration.zero);

      clearInteractions(mockRepo);
      when(() => mockRepo.reportDriverLocation(location: any(named: 'location')))
          .thenAnswer((_) async {});

      locationController.add(farAway);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockRepo.reportDriverLocation(location: farAway),
      ).called(1);
    });

    test('stopReporting cancels the subscription', () async {
      const location = LatLng(30.0, 31.0);

      useCase.startReporting();
      useCase.stopReporting();

      locationController.add(location);
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => mockRepo.reportDriverLocation(location: any(named: 'location')),
      );
    });

    test('stopReporting resets lastReportedLocation', () async {
      const first = LatLng(30.0, 31.0);
      const second = LatLng(30.0, 31.0); // Same location.

      useCase.startReporting();
      locationController.add(first);
      await Future<void>.delayed(Duration.zero);

      useCase.stopReporting();

      // Start again — should report immediately even though same coords.
      useCase.startReporting();
      locationController.add(second);
      await Future<void>.delayed(Duration.zero);

      // First call from first start, second call from second start.
      verify(
        () => mockRepo.reportDriverLocation(location: any(named: 'location')),
      ).called(2);
    });
  });
}
