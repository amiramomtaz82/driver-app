import 'package:driver_app/config/base_response/base_response.dart';

import '../models/message_response_model.dart';
import '../models/verify_otp_response_model.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<MessageResponseModel>> forgetPassword({
    required String email,
  });

  Future<BaseResponse<ResetTokenModel>> verifyOtp({
    required String email,
    required String otpCode,
  });

  Future<BaseResponse<MessageResponseModel>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });
}
