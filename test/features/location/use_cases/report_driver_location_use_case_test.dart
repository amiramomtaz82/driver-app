import 'dart:async';

import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/location/data/service/distance_calculator_service.dart';
import 'package:driver_app/features/location/domain/entities/location_coordinates.dart';
import 'package:driver_app/features/location/domain/repo/location_repo.dart';
import 'package:driver_app/features/location/domain/use_cases/report_driver_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepo extends Mock implements LocationRepo {}

class MockDistanceCalculatorService extends Mock
    implements DistanceCalculatorService {}

void main() {
  late MockLocationRepo mockRepo;
  late MockDistanceCalculatorService mockDistanceCalculator;
  late ReportDriverLocationUseCase useCase;
  late StreamController<BaseResponse<LocationCoordinates>> locationController;

  setUpAll(() {
    registerFallbackValue(const LocationCoordinates(latitude: 0, longitude: 0));
  });

  setUp(() {
    mockRepo = MockLocationRepo();
    mockDistanceCalculator = MockDistanceCalculatorService();
    useCase = ReportDriverLocationUseCase(mockRepo, mockDistanceCalculator);
    locationController =
        StreamController<BaseResponse<LocationCoordinates>>.broadcast();

    when(() => mockRepo.watchDriverLocation())
        .thenAnswer((_) => locationController.stream);
    when(() => mockRepo.reportDriverLocation(location: any(named: 'location')))
        .thenAnswer((_) async => const SuccessResponse(null));
  });

  tearDown(() {
    useCase.stopReporting();
    locationController.close();
  });

  group('ReportDriverLocationUseCase —', () {
    test('reports the first location immediately', () async {
      const firstLocation =
          LocationCoordinates(latitude: 30.0, longitude: 31.0);

      useCase.startReporting();
      locationController.add(const SuccessResponse(firstLocation));

      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockRepo.reportDriverLocation(location: firstLocation),
      ).called(1);
    });

    test('does NOT report when distance < 100 m', () async {
      const origin = LocationCoordinates(latitude: 30.0, longitude: 31.0);
      const nearby = LocationCoordinates(latitude: 30.00009, longitude: 31.0);

      when(() => mockDistanceCalculator.calculateDistanceInMeters(origin, nearby))
          .thenReturn(10.0);

      useCase.startReporting();
      locationController.add(const SuccessResponse(origin));
      await Future<void>.delayed(Duration.zero);

      clearInteractions(mockRepo);
      when(() => mockRepo.reportDriverLocation(location: any(named: 'location')))
          .thenAnswer((_) async => const SuccessResponse(null));

      locationController.add(const SuccessResponse(nearby));
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => mockRepo.reportDriverLocation(location: any(named: 'location')),
      );
    });

    test('reports when distance >= 100 m', () async {
      const origin = LocationCoordinates(latitude: 30.0, longitude: 31.0);
      const farAway = LocationCoordinates(latitude: 30.01, longitude: 31.0);

      when(() => mockDistanceCalculator.calculateDistanceInMeters(origin, farAway))
          .thenReturn(1100.0);

      useCase.startReporting();
      locationController.add(const SuccessResponse(origin));
      await Future<void>.delayed(Duration.zero);

      clearInteractions(mockRepo);
      when(() => mockRepo.reportDriverLocation(location: any(named: 'location')))
          .thenAnswer((_) async => const SuccessResponse(null));

      locationController.add(const SuccessResponse(farAway));
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockRepo.reportDriverLocation(location: farAway),
      ).called(1);
    });

    test('stopReporting cancels the subscription', () async {
      const location = LocationCoordinates(latitude: 30.0, longitude: 31.0);

      useCase.startReporting();
      useCase.stopReporting();

      locationController.add(const SuccessResponse(location));
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => mockRepo.reportDriverLocation(location: any(named: 'location')),
      );
    });

    test('stopReporting resets lastReportedLocation', () async {
      const first = LocationCoordinates(latitude: 30.0, longitude: 31.0);
      const second = LocationCoordinates(latitude: 30.0, longitude: 31.0);

      useCase.startReporting();
      locationController.add(const SuccessResponse(first));
      await Future<void>.delayed(Duration.zero);

      useCase.stopReporting();

      useCase.startReporting();
      locationController.add(const SuccessResponse(second));
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockRepo.reportDriverLocation(location: any(named: 'location')),
      ).called(2);
    });
  });
}
