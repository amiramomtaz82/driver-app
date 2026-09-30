import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/domain/entities/country.dart';
import 'package:driver_app/features/auth/domain/entities/register_entity.dart';
import 'package:driver_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:driver_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:driver_app/features/auth/domain/repo/auth_repo.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_countries_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/get_vehicle_type_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/register_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}
class FakeRegisterEntity extends Fake implements RegisterEntity {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late RegisterUseCase registerUseCase;
  late GetCountriesUseCase getCountriesUseCase;
  late GetVehicleTypesUseCase getVehicleTypesUseCase;

  setUpAll(() {
    registerFallbackValue(FakeRegisterEntity());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    registerUseCase = RegisterUseCase(mockAuthRepo);
    getCountriesUseCase = GetCountriesUseCase(mockAuthRepo);
    getVehicleTypesUseCase = GetVehicleTypesUseCase(mockAuthRepo);
  });

  group('RegisterUseCase', () {
    const params = RegisterEntity(
      firstName: 'Ahmed',
      lastName: 'Ali',
      email: 'ahmed@example.com',
      phone: '01012345678',
      password: 'Password123!',
      gender: 'male',
      vehicleType: 'car',
      vehicleNumber: '123 XYZ',
      nationalId: '12345678901234',
    );

    test('should return SuccessResponse when authRepo.register succeeds', () async {
      const expectedResponse = RegisterEntityResponse(
        message: 'Account created successfully',
        token: 'auth_token_xyz',
        success: true,
      );

      when(() => mockAuthRepo.register(any())).thenAnswer(
        (_) async => const SuccessResponse(expectedResponse),
      );

      final result = await registerUseCase(params);

      expect(result, isA<SuccessResponse<RegisterEntityResponse>>());
      final success = result as SuccessResponse<RegisterEntityResponse>;
      expect(success.data.token, equals('auth_token_xyz'));
      expect(success.data.success, isTrue);
      verify(() => mockAuthRepo.register(params)).called(1);
    });

    test('should return ErrorResponse when authRepo.register fails', () async {
      when(() => mockAuthRepo.register(any())).thenAnswer(
        (_) async => ErrorResponse(errMessage: 'Email already exists'),
      );

      final result = await registerUseCase(params);

      expect(result, isA<ErrorResponse<RegisterEntityResponse>>());
      final error = result as ErrorResponse<RegisterEntityResponse>;
      expect(error.errMessage, equals('Email already exists'));
      verify(() => mockAuthRepo.register(params)).called(1);
    });
  });

  group('GetCountriesUseCase', () {
    const countries = [
      Country(id: 'eg', name: 'Egypt', flag: '🇪🇬', code: '+20'),
      Country(id: 'sa', name: 'Saudi Arabia', flag: '🇸🇦', code: '+966'),
    ];

    test('should return SuccessResponse with countries list when authRepo.getCountries succeeds', () async {
      when(() => mockAuthRepo.getCountries()).thenAnswer(
        (_) async => const SuccessResponse(countries),
      );

      final result = await getCountriesUseCase();

      expect(result, isA<SuccessResponse<List<Country>>>());
      final success = result as SuccessResponse<List<Country>>;
      expect(success.data, equals(countries));
      expect(success.data.length, equals(2));
      verify(() => mockAuthRepo.getCountries()).called(1);
    });

    test('should return ErrorResponse when authRepo.getCountries fails', () async {
      when(() => mockAuthRepo.getCountries()).thenAnswer(
        (_) async => ErrorResponse(errMessage: 'Server unreachable'),
      );

      final result = await getCountriesUseCase();

      expect(result, isA<ErrorResponse<List<Country>>>());
      final error = result as ErrorResponse<List<Country>>;
      expect(error.errMessage, equals('Server unreachable'));
      verify(() => mockAuthRepo.getCountries()).called(1);
    });
  });

  group('GetVehicleTypesUseCase', () {
    const vehicleTypes = [
      VehicleType(id: 'car', name: 'Car'),
      VehicleType(id: 'motorcycle', name: 'Motorcycle'),
    ];

    test('should return SuccessResponse with vehicle types when authRepo.getVehicleTypes succeeds', () async {
      when(() => mockAuthRepo.getVehicleTypes()).thenAnswer(
        (_) async => const SuccessResponse(vehicleTypes),
      );

      final result = await getVehicleTypesUseCase();

      expect(result, isA<SuccessResponse<List<VehicleType>>>());
      final success = result as SuccessResponse<List<VehicleType>>;
      expect(success.data, equals(vehicleTypes));
      expect(success.data.length, equals(2));
      verify(() => mockAuthRepo.getVehicleTypes()).called(1);
    });

    test('should return ErrorResponse when authRepo.getVehicleTypes fails', () async {
      when(() => mockAuthRepo.getVehicleTypes()).thenAnswer(
        (_) async => ErrorResponse(errMessage: 'Failed to load vehicle types'),
      );

      final result = await getVehicleTypesUseCase();

      expect(result, isA<ErrorResponse<List<VehicleType>>>());
      final error = result as ErrorResponse<List<VehicleType>>;
      expect(error.errMessage, equals('Failed to load vehicle types'));
      verify(() => mockAuthRepo.getVehicleTypes()).called(1);
    });
  });
}
