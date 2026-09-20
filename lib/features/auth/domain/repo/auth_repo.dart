import 'package:driver_app/config/base_response/base_response.dart';

import '../entities/auth_message_entity.dart';
import '../entities/reset_token_entity.dart';

import '../../data/models/register_request_dto.dart';
import '../../data/models/register_response_dto.dart';
import '../entities/country.dart';
import '../entities/vehicle_type_entity.dart';
abstract interface class AuthRepo {
  Future<BaseResponse<AuthMessageEntity>> forgetPassword({
    required String email,
  });

  Future<BaseResponse<ResetToken>> verifyOtp({
    required String email,
    required String otpCode,
  });

  Future<BaseResponse<AuthMessageEntity>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });




  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto request);
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes();
  Future<BaseResponse<List<Country>>> getCountries();
}
