import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/domain/models/login_request_model.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:driver_app/features/auth/domain/entities/register_response_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/safe_call.dart';
import '../../domain/entities/auth_message_entity.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/reset_token_entity.dart';
import '../../domain/entities/register_form.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../models/register_request_dto.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(
      this._authRemoteDataSource,
      this._authLocalDataSource,
      );

  // Toggle: change to false when backend endpoints are ready!



  @override
  Future<BaseResponse<RegisterEntityResponse>> register(RegisterForm params) {
    return safeCall(() async {
      // 1. Map domain params (String paths) to DTO (MultipartFiles)
      final requestDto = await RegisterRequestDto.fromParams(params);
      // 2. Call remote data source
      final responseDto = await _authRemoteDataSource.register(requestDto);
      // 3. Map output DTO to Domain Entity
      return responseDto.toEntity();
    });
  }
  @override
  Future<BaseResponse<List<Country>>> getCountries() async {

    return safeCall(() async {
      final dtos = await _authRemoteDataSource.getCountries();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
}
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
      await _authLocalDataSource.saveToken(result.token);
      if (rememberMe) {
        await _authLocalDataSource.saveRefreshToken(result.refreshToken);
      }
      return SuccessResponse(result);
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }
  @override
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes() async {

    return safeCall(() async {
      final dtos = await _authRemoteDataSource.getVehicleTypes();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }
  @override
  Future<BaseResponse<ResetToken>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final result = await _authRemoteDataSource.verifyOtp(
        email: email,
        otpCode: otpCode,
      );
      return SuccessResponse(result.toEntity());
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }
  @override
  Future<BaseResponse<AuthMessageEntity>> resetPassword({
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
      return SuccessResponse(result.toEntity());
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }
  @override
  Future<BaseResponse<AuthMessageEntity>> forgetPassword({
    required String email,
  }) async {
    try {
      final result = await _authRemoteDataSource.forgetPassword(email: email);
      return SuccessResponse(result.toEntity());
    } catch (e) {
      return ErrorResponse(error: e);
    }
  }
}
