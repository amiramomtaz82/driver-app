import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/secure_storage/secure_storage.dart';
import 'package:driver_app/features/profile/data/data_source/remote_data_source.dart';
import 'package:driver_app/features/profile/data/models/driver_vehicle_dto.dart';
import 'package:driver_app/features/profile/data/models/update_user_profile_request.dart';
import 'package:driver_app/features/profile/data/models/update_vehicle_request_dto.dart';
import 'package:driver_app/features/profile/data/models/user_profile_dto.dart';
import 'package:driver_app/features/profile/data/repo_imp/profile_repo_imp.dart';
import 'package:driver_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:driver_app/features/profile/domain/entities/update_user_profile_params.dart';
import 'package:driver_app/features/profile/domain/entities/update_vehicle_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock implements ProfileRemoteDataSource {}
class MockSecureStorage extends Mock implements SecureStorage {}
class FakeUpdateUserProfileRequestDto extends Fake implements UpdateUserProfileRequestDto {}
class FakeUpdateVehicleRequestDto extends Fake implements UpdateVehicleRequestDto {}

void main() {
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockSecureStorage mockSecureStorage;
  late ProfileRepoImpl repo;

  setUpAll(() {
    registerFallbackValue(FakeUpdateUserProfileRequestDto());
    registerFallbackValue(FakeUpdateVehicleRequestDto());
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockSecureStorage = MockSecureStorage();
    repo = ProfileRepoImpl(mockRemoteDataSource, mockSecureStorage);
  });

  group('ProfileRepoImpl - getProfile', () {
    const userDto = UserProfileDto(
      id: 'driver_1',
      fullName: 'Amira Momtaz',
      email: 'amira@example.com',
      phone: '01012345678',
      gender: 'Female',
    );

    const vehicleDto = DriverVehicleDto(
      vehicleType: 'Car',
      vehicleNumber: 'ABC 1234',
    );

    test('should return SuccessResponse with combined entity when both calls succeed', () async {
      when(() => mockRemoteDataSource.getUserProfile()).thenAnswer((_) async => userDto);
      when(() => mockRemoteDataSource.getDriverVehicle()).thenAnswer((_) async => vehicleDto);

      final result = await repo.getProfile();

      expect(result, isA<SuccessResponse<DriverProfileEntity>>());
      final entity = (result as SuccessResponse<DriverProfileEntity>).data;
      expect(entity.id, equals('driver_1'));
      expect(entity.fullName, equals('Amira Momtaz'));
      expect(entity.vehicle?.vehicleNumber, equals('ABC 1234'));
      verify(() => mockRemoteDataSource.getUserProfile()).called(1);
      verify(() => mockRemoteDataSource.getDriverVehicle()).called(1);
    });

    test('should return ErrorResponse when getDriverVehicle throws', () async {
      when(() => mockRemoteDataSource.getUserProfile()).thenAnswer((_) async => userDto);
      when(() => mockRemoteDataSource.getDriverVehicle()).thenThrow(Exception('Vehicle not found'));

      final result = await repo.getProfile();

      expect(result, isA<ErrorResponse<DriverProfileEntity>>());
      verify(() => mockRemoteDataSource.getUserProfile()).called(1);
      verify(() => mockRemoteDataSource.getDriverVehicle()).called(1);
    });

    test('should return ErrorResponse when getUserProfile throws', () async {
      when(() => mockRemoteDataSource.getUserProfile()).thenThrow(Exception('User not found'));

      final result = await repo.getProfile();

      expect(result, isA<ErrorResponse<DriverProfileEntity>>());
      verify(() => mockRemoteDataSource.getUserProfile()).called(1);
      verifyNever(() => mockRemoteDataSource.getDriverVehicle());
    });
  });

  group('ProfileRepoImpl - updateUserProfile', () {
    const params = UpdateUserProfileParams(
      fullName: 'Amira Momtaz',
      email: 'amira@example.com',
      phone: '01012345678',
      gender: 'Female',
    );

    const responseDto = UserProfileDto(
      id: 'driver_1',
      fullName: 'Amira Momtaz',
      email: 'amira@example.com',
      phone: '01012345678',
      gender: 'Female',
    );

    test('should return SuccessResponse when update succeeds', () async {
      when(() => mockRemoteDataSource.updateUserProfile(any()))
          .thenAnswer((_) async => responseDto);

      final result = await repo.updateUserProfile(params);

      expect(result, isA<SuccessResponse<DriverProfileEntity>>());
      final entity = (result as SuccessResponse<DriverProfileEntity>).data;
      expect(entity.fullName, equals('Amira Momtaz'));
      verify(() => mockRemoteDataSource.updateUserProfile(any())).called(1);
    });

    test('should return ErrorResponse when update throws', () async {
      when(() => mockRemoteDataSource.updateUserProfile(any()))
          .thenThrow(Exception('Failed to update'));

      final result = await repo.updateUserProfile(params);

      expect(result, isA<ErrorResponse<DriverProfileEntity>>());
      verify(() => mockRemoteDataSource.updateUserProfile(any())).called(1);
    });
  });

  group('ProfileRepoImpl - updateVehicle', () {
    const params = UpdateVehicleParams(
      vehicleType: 'Car',
      vehicleNumber: 'XYZ 9999',
    );

    test('should return SuccessResponse when updateDriverVehicle succeeds', () async {
      when(() => mockRemoteDataSource.updateDriverVehicle(any()))
          .thenAnswer((_) async {});

      final result = await repo.updateVehicle(params);

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRemoteDataSource.updateDriverVehicle(any())).called(1);
    });

    test('should return ErrorResponse when updateDriverVehicle throws', () async {
      when(() => mockRemoteDataSource.updateDriverVehicle(any()))
          .thenThrow(Exception('Vehicle update error'));

      final result = await repo.updateVehicle(params);

      expect(result, isA<ErrorResponse<void>>());
      verify(() => mockRemoteDataSource.updateDriverVehicle(any())).called(1);
    });
  });

  group('ProfileRepoImpl - logout', () {
    test('should call remote logout and wipe secure storage in finally', () async {
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async {});
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async {});

      final result = await repo.logout();

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockSecureStorage.deleteAll()).called(1);
    });

    test('should wipe secure storage even if remote logout fails', () async {
      when(() => mockRemoteDataSource.logout()).thenThrow(Exception('Network error'));
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async {});

      final result = await repo.logout();

      expect(result, isA<ErrorResponse<void>>());
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockSecureStorage.deleteAll()).called(1);
    });
  });
}
