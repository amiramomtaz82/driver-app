import '../../../../config/base_response/base_response.dart';
import '../../data/models/register_request_dto.dart';
import '../../data/models/register_response_dto.dart';
import '../entities/country.dart';
import '../entities/vehicle_type_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto request);
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes();
  Future<BaseResponse<List<Country>>> getCountries();
}
