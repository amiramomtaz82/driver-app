import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:driver_app/features/profile/domain/entities/update_user_profile_params.dart';
import 'package:driver_app/features/profile/domain/entities/update_vehicle_params.dart';
import 'package:driver_app/features/profile/domain/repo/profile_repo.dart';
import 'package:driver_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:driver_app/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:driver_app/features/profile/domain/use_cases/update_user_profile_use_case.dart';
import 'package:driver_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}
class FakeUpdateUserProfileParams extends Fake implements UpdateUserProfileParams {}
class FakeUpdateVehicleParams extends Fake implements UpdateVehicleParams {}

void main() {
  late MockProfileRepo mockRepo;
  late GetProfileUseCase getProfileUseCase;
  late UpdateUserProfileUseCase updateUserProfileUseCase;
  late UpdateVehicleUseCase updateVehicleUseCase;
  late LogoutUseCase logoutUseCase;

  const testProfile = DriverProfileEntity(
    id: 'driver_1',
    fullName: 'Amira Momtaz',
    email: 'amira@example.com',
    phone: '01012345678',
    gender: 'Female',
  );

  setUpAll(() {
    registerFallbackValue(FakeUpdateUserProfileParams());
    registerFallbackValue(FakeUpdateVehicleParams());
  });

  setUp(() {
    mockRepo = MockProfileRepo();
    getProfileUseCase = GetProfileUseCase(mockRepo);
    updateUserProfileUseCase = UpdateUserProfileUseCase(mockRepo);
    updateVehicleUseCase = UpdateVehicleUseCase(mockRepo);
    logoutUseCase = LogoutUseCase(mockRepo);
  });

  group('GetProfileUseCase', () {
    test('returns DriverProfileEntity when repo succeeds', () async {
      when(() => mockRepo.getProfile()).thenAnswer(
        (_) async => const SuccessResponse(testProfile),
      );

      final result = await getProfileUseCase();

      expect(result, isA<SuccessResponse<DriverProfileEntity>>());
      final data = (result as SuccessResponse<DriverProfileEntity>).data;
      expect(data, equals(testProfile));
      verify(() => mockRepo.getProfile()).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      final error = Exception('Failed to load profile');
      when(() => mockRepo.getProfile()).thenAnswer(
        (_) async => ErrorResponse(error: error),
      );

      final result = await getProfileUseCase();

      expect(result, isA<ErrorResponse<DriverProfileEntity>>());
      verify(() => mockRepo.getProfile()).called(1);
    });
  });

  group('UpdateUserProfileUseCase', () {
    const params = UpdateUserProfileParams(
      fullName: 'Amira Momtaz',
      email: 'amira@example.com',
      phone: '01012345678',
      gender: 'Female',
    );

    test('passes typed params and returns updated entity on success', () async {
      when(() => mockRepo.updateUserProfile(any())).thenAnswer(
        (_) async => const SuccessResponse(testProfile),
      );

      final result = await updateUserProfileUseCase(params);

      expect(result, isA<SuccessResponse<DriverProfileEntity>>());
      final data = (result as SuccessResponse<DriverProfileEntity>).data;
      expect(data, equals(testProfile));
      verify(() => mockRepo.updateUserProfile(params)).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      final error = Exception('Failed to update profile');
      when(() => mockRepo.updateUserProfile(any())).thenAnswer(
        (_) async => ErrorResponse(error: error),
      );

      final result = await updateUserProfileUseCase(params);

      expect(result, isA<ErrorResponse<DriverProfileEntity>>());
      verify(() => mockRepo.updateUserProfile(params)).called(1);
    });
  });

  group('UpdateVehicleUseCase', () {
    const params = UpdateVehicleParams(
      vehicleType: 'Car',
      vehicleNumber: 'ABC 1234',
    );

    test('passes typed params and returns SuccessResponse on success', () async {
      when(() => mockRepo.updateVehicle(any())).thenAnswer(
        (_) async => const SuccessResponse(null),
      );

      final result = await updateVehicleUseCase(params);

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRepo.updateVehicle(params)).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      final error = Exception('Failed to update vehicle');
      when(() => mockRepo.updateVehicle(any())).thenAnswer(
        (_) async => ErrorResponse(error: error),
      );

      final result = await updateVehicleUseCase(params);

      expect(result, isA<ErrorResponse<void>>());
      verify(() => mockRepo.updateVehicle(params)).called(1);
    });
  });

  group('LogoutUseCase', () {
    test('calls repo logout and returns SuccessResponse on success', () async {
      when(() => mockRepo.logout()).thenAnswer(
        (_) async => const SuccessResponse(null),
      );

      final result = await logoutUseCase();

      expect(result, isA<SuccessResponse<void>>());
      verify(() => mockRepo.logout()).called(1);
    });

    test('returns ErrorResponse when repo logout fails', () async {
      final error = Exception('Logout failed');
      when(() => mockRepo.logout()).thenAnswer(
        (_) async => ErrorResponse(error: error),
      );

      final result = await logoutUseCase();

      expect(result, isA<ErrorResponse<void>>());
      verify(() => mockRepo.logout()).called(1);
    });
  });
}
