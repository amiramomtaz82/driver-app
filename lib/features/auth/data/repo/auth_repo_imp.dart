import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/domain/models/login_request_model.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repo/auth_repo.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<BaseResponse<LoginResponseModel>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final result = await _authRemoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      if (rememberMe) {
        await _authLocalDataSource.saveToken(result.token);
        await _authLocalDataSource.saveRefreshToken(result.refreshToken);
      }
      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }
}
