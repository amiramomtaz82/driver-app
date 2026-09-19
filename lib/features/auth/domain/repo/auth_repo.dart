import 'package:driver_app/config/base_response/base_response.dart';

import '../entities/auth_message_entity.dart';
import '../entities/reset_token_entity.dart';

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
}
