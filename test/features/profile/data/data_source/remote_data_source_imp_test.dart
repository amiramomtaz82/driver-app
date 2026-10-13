import 'package:driver_app/features/profile/api/profile_api_client.dart';
import 'package:driver_app/features/profile/data/data_source/remote_data_source_imp.dart';
import 'package:driver_app/features/profile/data/models/driver_vehicle_dto.dart';
import 'package:driver_app/features/profile/data/models/update_user_profile_request.dart';
import 'package:driver_app/features/profile/data/models/update_vehicle_request_dto.dart';
import 'package:driver_app/features/profile/data/models/user_profile_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileClient extends Mock implements ProfileClient {}

void main() {
  late MockProfileClient mockClient;
  late ProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockProfileClient();
    dataSource = ProfileRemoteDataSourceImpl(mockClient);
  });

  group('ProfileRemoteDataSourceImpl - getUserProfile', () {
    const expectedDto = UserProfileDto(
      id: 'driver_123',
      fullName: 'Amira Momtaz',
      email: 'amira@example.com',
      phone: '01012345678',
      gender: 'Female',
    );

    test('should return UserProfileDto when client succeeds', () async {
      when(() => mockClient.getUserProfile()).thenAnswer((_) async => expectedDto);

      final result = await dataSource.getUserProfile();

      expect(result, equals(expectedDto));
      expect(result.id, equals('driver_123'));
      expect(result.fullName, equals('Amira Momtaz'));
      verify(() => mockClient.getUserProfile()).called(1);
    });

    test('should rethrow exception when client fails', () async {
      final exception = Exception('Failed to fetch user profile');
      when(() => mockClient.getUserProfile()).thenThrow(exception);

      expect(() => dataSource.getUserProfile(), throwsA(equals(exception)));
      verify(() => mockClient.getUserProfile()).called(1);
    });
  });

  group('ProfileRemoteDataSourceImpl - updateUserProfile', () {
    const request = UpdateUserProfileRequestDto(
      fullName: 'Amira Updated',
      email: 'amira@example.com',
      phone: '01099999999',
      gender: 'Female',
    );

    const updatedDto = UserProfileDto(
      id: 'driver_123',
      fullName: 'Amira Updated',
      email: 'amira@example.com',
      phone: '01099999999',
      gender: 'Female',
    );

    test('should return updated UserProfileDto when client succeeds', () async {
      when(() => mockClient.updateUserProfile(any()))
          .thenAnswer((_) async => updatedDto);

      final result = await dataSource.updateUserProfile(request);

      expect(result, equals(updatedDto));
      expect(result.fullName, equals('Amira Updated'));
      verify(() => mockClient.updateUserProfile(request.toMap())).called(1);
    });

    test('should rethrow exception when client fails', () async {
      final exception = Exception('Network error updating profile');
      when(() => mockClient.updateUserProfile(any())).thenThrow(exception);

      expect(() => dataSource.updateUserProfile(request), throwsA(equals(exception)));
      verify(() => mockClient.updateUserProfile(request.toMap())).called(1);
    });
  });

  group('ProfileRemoteDataSourceImpl - getDriverVehicle', () {
    const vehicleDto = DriverVehicleDto(
      vehicleType: 'Car',
      vehicleNumber: 'ABC 1234',
      licensePhotoUrl: 'https://example.com/license.jpg',
    );

    test('should return DriverVehicleDto when client succeeds', () async {
      when(() => mockClient.getDriverVehicle()).thenAnswer((_) async => vehicleDto);

      final result = await dataSource.getDriverVehicle();

      expect(result, equals(vehicleDto));
      expect(result.vehicleType, equals('Car'));
      expect(result.vehicleNumber, equals('ABC 1234'));
      verify(() => mockClient.getDriverVehicle()).called(1);
    });

    test('should rethrow exception when client fails', () async {
      final exception = Exception('Vehicle not found');
      when(() => mockClient.getDriverVehicle()).thenThrow(exception);

      expect(() => dataSource.getDriverVehicle(), throwsA(equals(exception)));
      verify(() => mockClient.getDriverVehicle()).called(1);
    });
  });

  group('ProfileRemoteDataSourceImpl - updateDriverVehicle', () {
    const request = UpdateVehicleRequestDto(
      vehicleType: 'Car',
      vehicleNumber: 'XYZ 7890',
    );

    test('should complete normally when client succeeds', () async {
      when(() => mockClient.updateDriverVehicle(any())).thenAnswer((_) async {});

      await dataSource.updateDriverVehicle(request);

      verify(() => mockClient.updateDriverVehicle(request.toMap())).called(1);
    });

    test('should rethrow exception when client fails', () async {
      final exception = Exception('Vehicle update failed');
      when(() => mockClient.updateDriverVehicle(any())).thenThrow(exception);

      expect(() => dataSource.updateDriverVehicle(request), throwsA(equals(exception)));
      verify(() => mockClient.updateDriverVehicle(request.toMap())).called(1);
    });
  });

  group('ProfileRemoteDataSourceImpl - logout', () {
    test('should complete normally when client succeeds', () async {
      when(() => mockClient.logout()).thenAnswer((_) async {});

      await dataSource.logout();

      verify(() => mockClient.logout()).called(1);
    });

    test('should rethrow exception when client fails', () async {
      final exception = Exception('Logout network error');
      when(() => mockClient.logout()).thenThrow(exception);

      expect(() => dataSource.logout(), throwsA(equals(exception)));
      verify(() => mockClient.logout()).called(1);
    });
  });
}
