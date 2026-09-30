import 'package:driver_app/features/auth/data/models/country_dto.dart';
import 'package:driver_app/features/auth/data/models/register_request_dto.dart';
import 'package:driver_app/features/auth/data/models/register_response_dto.dart';
import 'package:driver_app/features/auth/data/models/vehicle_type_dto.dart';
import 'package:driver_app/features/auth/domain/entities/register_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterResponseDto', () {
    test('fromJson should deserialize JSON correctly', () {
      final json = {
        'message': 'Success',
        'token': 'jwt_123',
        'success': true,
      };

      final dto = RegisterResponseDto.fromJson(json);

      expect(dto.message, equals('Success'));
      expect(dto.token, equals('jwt_123'));
      expect(dto.success, isTrue);
    });

    test('toEntity should map to RegisterEntityResponse', () {
      const dto = RegisterResponseDto(
        message: 'Account created',
        token: 'token_abc',
        success: true,
      );

      final entity = dto.toEntity();

      expect(entity.message, equals('Account created'));
      expect(entity.token, equals('token_abc'));
      expect(entity.success, isTrue);
    });
  });

  group('RegisterRequestDto', () {
    test('toMap should serialize non-null fields correctly', () {
      const dto = RegisterRequestDto(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '01012345678',
        password: 'Password123!',
        gender: 'male',
        vehicleType: 'car',
        vehicleNumber: '123 ABC',
        nationalId: '12345678901234',
      );

      final map = dto.toMap();

      expect(map['firstName'], equals('John'));
      expect(map['lastName'], equals('Doe'));
      expect(map['email'], equals('john@example.com'));
      expect(map['phone'], equals('01012345678'));
      expect(map['password'], equals('Password123!'));
      expect(map['gender'], equals('male'));
      expect(map['vehicleType'], equals('car'));
      expect(map['vehicleNumber'], equals('123 ABC'));
      expect(map['nationalId'], equals('12345678901234'));
      expect(map.containsKey('vehicleLicense'), isFalse);
      expect(map.containsKey('idImage'), isFalse);
    });

    test('fromParams should map domain entity without file paths to DTO', () async {
      const entity = RegisterEntity(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        phone: '01123456789',
        password: 'Password123!',
        gender: 'female',
        vehicleType: 'motorcycle',
        vehicleNumber: '456 DEF',
        nationalId: '98765432101234',
      );

      final dto = await RegisterRequestDto.fromParams(entity);

      expect(dto.firstName, equals('Jane'));
      expect(dto.lastName, equals('Smith'));
      expect(dto.email, equals('jane@example.com'));
      expect(dto.phone, equals('01123456789'));
      expect(dto.password, equals('Password123!'));
      expect(dto.gender, equals('female'));
      expect(dto.vehicleType, equals('motorcycle'));
      expect(dto.vehicleNumber, equals('456 DEF'));
      expect(dto.nationalId, equals('98765432101234'));
      expect(dto.vehicleLicense, isNull);
      expect(dto.idImage, isNull);
    });
  });

  group('CountryDto and VehicleTypeDto', () {
    test('CountryDto should serialize from JSON and map to Entity', () {
      final json = {
        '_id': 'eg',
        'name': 'Egypt',
        'flag': '🇪🇬',
        'code': '+20',
      };

      final dto = CountryDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, equals('eg'));
      expect(entity.name, equals('Egypt'));
      expect(entity.flag, equals('🇪🇬'));
      expect(entity.code, equals('+20'));
    });

    test('VehicleTypeDto should serialize from JSON and map to Entity', () {
      final json = {
        '_id': 'car',
        'name': 'Car',
      };

      final dto = VehicleTypeDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, equals('car'));
      expect(entity.name, equals('Car'));
    });
  });
}
