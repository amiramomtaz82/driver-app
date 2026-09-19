import '../../domain/models/message_response_model.dart';
import '../../domain/models/verify_otp_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<MessageResponseModel> forgetPassword({required String email});

  Future<ResetTokenModel> verifyOtp({
    required String email,
    required String otpCode,
  });

  Future<MessageResponseModel> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });
}
