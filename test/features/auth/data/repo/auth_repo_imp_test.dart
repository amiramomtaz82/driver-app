import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/data/data_source/local_data_source.dart';
import 'package:driver_app/features/auth/data/data_source/remote_data_source.dart';
import 'package:driver_app/features/auth/data/models/country_dto.dart';
import 'package:driver_app/features/auth/data/models/register_request_dto.dart';
import 'package:driver_app/features/auth/data/models/register_response_dto.dart';
import 'package:driver_app/features/auth/data/models/vehicle_type_dto.dart';
import 'package:driver_app/features/auth/data/repo/auth_repo_imp.dart';
import 'package:driver_app/features/auth/domain/entities/country.dart';
import 'package:driver_app/features/auth/domain/entities/register_form.dart';
import 'package:driver_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:driver_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class FakeRegisterRequestDto extends Fake implements RegisterRequestDto {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late AuthRepoImpl authRepo;

  setUpAll(() {
    registerFallbackValue(FakeRegisterRequestDto());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    authRepo = AuthRepoImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('AuthRepoImpl - register', () {
    const form = RegisterForm(
      firstName: 'Sarah',
      lastName: 'Hassan',
      email: 'sarah@example.com',
      phone: '01123456789',
      password: 'Password123!',
      gender: 'female',
      vehicleType: 'car',
      vehicleNumber: '456 DEF',
      nationalId: '98765432101234',
    );

    test('should return SuccessResponse when remoteDataSource.register succeeds', () async {
      const responseDto = RegisterResponseDto(
        message: 'Registered successfully',
        token: 'token_123',
        success: true,
      );

      when(() => mockRemoteDataSource.register(any())).thenAnswer((_) async => responseDto);

      final result = await authRepo.register(form);

      expect(result, isA<SuccessResponse<RegisterEntityResponse>>());
      final success = result as SuccessResponse<RegisterEntityResponse>;
      expect(success.data.token, equals('token_123'));
      expect(success.data.success, isTrue);
      verify(() => mockRemoteDataSource.register(any())).called(1);
    });

    test('should return ErrorResponse when remoteDataSource.register throws', () async {
      final exception = Exception('Registration failed');
      when(() => mockRemoteDataSource.register(any())).thenThrow(exception);

      final result = await authRepo.register(form);

      expect(result, isA<ErrorResponse<RegisterEntityResponse>>());
      final error = result as ErrorResponse<RegisterEntityResponse>;
      expect(error.error, equals(exception));
      verify(() => mockRemoteDataSource.register(any())).called(1);
    });
  });

  group('AuthRepoImpl - getCountries', () {
    test('should return SuccessResponse with mapped Country entities', () async {
      const countriesDto = [
        CountryDto(id: 'eg', name: 'Egypt', flag: '🇪🇬', code: '+20'),
      ];
      when(() => mockRemoteDataSource.getCountries())
          .thenAnswer((_) async => countriesDto);

      final result = await authRepo.getCountries();

      expect(result, isA<SuccessResponse<List<Country>>>());
      final success = result as SuccessResponse<List<Country>>;
      expect(success.data, isNotEmpty);
      expect(success.data.first.id, equals('eg'));
      expect(success.data.first.name, equals('Egypt'));
    });
  });

  group('AuthRepoImpl - getVehicleTypes', () {
    test('should return SuccessResponse with mapped VehicleType entities', () async {
      const vehicleTypesDto = [
        VehicleTypeDto(id: 'car', name: 'Car'),
      ];
      when(() => mockRemoteDataSource.getVehicleTypes())
          .thenAnswer((_) async => vehicleTypesDto);

      final result = await authRepo.getVehicleTypes();

      expect(result, isA<SuccessResponse<List<VehicleType>>>());
      final success = result as SuccessResponse<List<VehicleType>>;
      expect(success.data, isNotEmpty);
      expect(success.data.any((v) => v.id == 'car'), isTrue);
    });
  });
}
