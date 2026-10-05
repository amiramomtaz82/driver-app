import 'package:driver_app/features/auth/api/client/auth_client.dart';
import 'package:driver_app/features/auth/api/data_source/remote_data_source_imp.dart';
import 'package:driver_app/features/auth/data/models/country_dto.dart';
import 'package:driver_app/features/auth/data/models/register_request_dto.dart';
import 'package:driver_app/features/auth/data/models/register_response_dto.dart';
import 'package:driver_app/features/auth/data/models/vehicle_type_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthApiClient extends Mock implements AuthApiClient {}
class FakeRegisterRequestDto extends Fake implements RegisterRequestDto {}

void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeRegisterRequestDto());
  });

  setUp(() {
    mockApiClient = MockAuthApiClient();
    remoteDataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('AuthRemoteDataSourceImpl - register', () {
    const request = RegisterRequestDto(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phone: '01012345678',
      password: 'Password123!',
      gender: 'male',
      vehicleType: 'car',
      vehicleNumber: '123 ABC',
      nationalId: '12345678901234',
    );

    test('should return RegisterResponseDto when apiClient.register succeeds', () async {
      const expectedResponse = RegisterResponseDto(
        message: 'Account created successfully',
        token: 'fake_jwt_token',
        success: true,
      );

      when(() => mockApiClient.register(any())).thenAnswer((_) async => expectedResponse);

      final result = await remoteDataSource.register(request);

      expect(result, equals(expectedResponse));
      expect(result.token, equals('fake_jwt_token'));
      expect(result.success, isTrue);
      verify(() => mockApiClient.register(request.toMap())).called(1);
    });

    test('should rethrow exception when apiClient.register fails', () async {
      final exception = Exception('Network error');
      when(() => mockApiClient.register(any())).thenThrow(exception);

      expect(() => remoteDataSource.register(request), throwsA(equals(exception)));
      verify(() => mockApiClient.register(request.toMap())).called(1);
    });
  });

  group('AuthRemoteDataSourceImpl - getCountries', () {
    test('should return List<CountryDto> when apiClient.getCountries succeeds', () async {
      const countries = [
        CountryDto(id: 'eg', name: 'Egypt', flag: '🇪🇬', code: '+20'),
        CountryDto(id: 'sa', name: 'Saudi Arabia', flag: '🇸🇦', code: '+966'),
      ];

      when(() => mockApiClient.getCountries()).thenAnswer((_) async => countries);

      final result = await remoteDataSource.getCountries();

      expect(result, equals(countries));
      expect(result.length, equals(2));
      expect(result.first.name, equals('Egypt'));
      verify(() => mockApiClient.getCountries()).called(1);
    });

    test('should rethrow exception when apiClient.getCountries fails', () async {
      when(() => mockApiClient.getCountries()).thenThrow(Exception('Server error'));

      expect(() => remoteDataSource.getCountries(), throwsException);
      verify(() => mockApiClient.getCountries()).called(1);
    });
  });

  group('AuthRemoteDataSourceImpl - getVehicleTypes', () {
    test('should return List<VehicleTypeDto> when apiClient.getVehicleTypes succeeds', () async {
      const vehicleTypes = [
        VehicleTypeDto(id: 'car', name: 'Car'),
        VehicleTypeDto(id: 'motorcycle', name: 'Motorcycle'),
      ];

      when(() => mockApiClient.getVehicleTypes()).thenAnswer((_) async => vehicleTypes);

      final result = await remoteDataSource.getVehicleTypes();

      expect(result, equals(vehicleTypes));
      expect(result.length, equals(2));
      expect(result.first.id, equals('car'));
      verify(() => mockApiClient.getVehicleTypes()).called(1);
    });

    test('should rethrow exception when apiClient.getVehicleTypes fails', () async {
      when(() => mockApiClient.getVehicleTypes()).thenThrow(Exception('Server error'));

      expect(() => remoteDataSource.getVehicleTypes(), throwsException);
      verify(() => mockApiClient.getVehicleTypes()).called(1);
    });
  });
}
