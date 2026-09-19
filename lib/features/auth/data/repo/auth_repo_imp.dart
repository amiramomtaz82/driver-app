import 'package:driver_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/message_response_model.dart';
import '../../domain/models/verify_otp_response_model.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<BaseResponse<MessageResponseModel>> forgetPassword({
    required String email,
  }) async {
    try {
      final result = await _authRemoteDataSource.forgetPassword(email: email);
      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }

  @override
  Future<BaseResponse<ResetTokenModel>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final result = await _authRemoteDataSource.verifyOtp(
        email: email,
        otpCode: otpCode,
      );
      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }

  @override
  Future<BaseResponse<MessageResponseModel>> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final result = await _authRemoteDataSource.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }
}
