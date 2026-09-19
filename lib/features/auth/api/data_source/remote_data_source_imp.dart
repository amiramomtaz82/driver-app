import 'package:injectable/injectable.dart';

import '../../data/data_source/remote_data_source.dart';
import '../../data/models/message_response_model.dart';
import '../../data/models/verify_otp_response_model.dart';
import '../client/auth_client.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<MessageResponseModel> forgetPassword({required String email}) {
    return _authApiClient.forgetPassword({'email': email});
  }

  @override
  Future<VerifyOtpResponseData> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _authApiClient.verifyOtp({
      'email': email,
      'otp': otpCode,
    });
    return response.value;
  }

  @override
  Future<MessageResponseModel> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _authApiClient.resetPassword({
      'resetToken': resetToken,
      'newPassword': newPassword,
      'confirmPassword': confirmNewPassword,
    });
  }
}
