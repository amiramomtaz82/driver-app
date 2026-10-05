import '../models/country_dto.dart';
import '../models/register_request_dto.dart';
import '../models/register_response_dto.dart';
import '../models/vehicle_type_dto.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseDto> register(RegisterRequestDto request);
  Future<List<CountryDto>> getCountries();
  Future<List<VehicleTypeDto>> getVehicleTypes();


  Future<LoginResponseModel> login(LoginRequestModel request);
}
