import '../../../../config/base_response/base_response.dart';
import '../entities/auth_message_entity.dart';
import '../entities/country.dart';
import '../entities/register_response_entity.dart';
import '../entities/register_form.dart';
import '../entities/reset_token_entity.dart';
import '../entities/vehicle_type_entity.dart';
import '../models/login_response_model.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<RegisterEntityResponse>> register(RegisterForm params);
  Future<BaseResponse<AuthMessageEntity>> forgetPassword({
    required String email,
  });

  Future<BaseResponse<ResetToken>> verifyOtp({
    required String email,
    required String otpCode,
  });


  Future<BaseResponse<List<VehicleType>>> getVehicleTypes();
  Future<BaseResponse<List<Country>>> getCountries();

  Future<BaseResponse<AuthMessageEntity>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });


  Future<BaseResponse<LoginResponseModel>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<BaseResponse<AuthMessageEntity>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}
