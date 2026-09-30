import '../../../../config/base_response/base_response.dart';
import '../entities/country.dart';
import '../entities/register_response_entity.dart';
import '../entities/register_entity.dart';
import '../entities/vehicle_type_entity.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<RegisterEntityResponse>> register(RegisterEntity params);
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes();
  Future<BaseResponse<List<Country>>> getCountries();
}
