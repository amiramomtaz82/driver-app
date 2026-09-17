import '../models/country_dto.dart';
import '../models/register_request_dto.dart';
import '../models/register_response_dto.dart';
import '../models/vehicle_type_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseDto> register(RegisterRequestDto request);
  Future<List<CountryDto>> getCountries();
  Future<List<VehicleTypeDto>> getVehicleTypes();
}