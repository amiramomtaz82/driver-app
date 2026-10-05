import '../../../../config/base_response/base_response.dart';
import '../entities/country.dart';
import '../entities/register_response_entity.dart';
import '../entities/register_form.dart';
import '../entities/vehicle_type_entity.dart';

import '../models/login_response_model.dart';
abstract interface class AuthRepo {
  Future<BaseResponse<RegisterEntityResponse>> register(RegisterForm params);
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes();
  Future<BaseResponse<List<Country>>> getCountries();





  Future<BaseResponse<LoginResponseModel>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });
}
