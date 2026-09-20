
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/domain/models/login_request_model.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:injectable/injectable.dart';


import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_response/safe_call.dart';
import '../../domain/entities/auth_message_entity.dart';
import '../../domain/entities/country.dart';

import '../../domain/entities/reset_token_entity.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../models/country_dto.dart';
import '../models/register_request_dto.dart';
import '../models/register_response_dto.dart';
import '../models/vehicle_type_dto.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);


  static const bool useDummyData = true;

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

  @override
  Future<BaseResponse<RegisterResponseDto>> register(
      RegisterRequestDto request) {
    return safeCall(() => _authRemoteDataSource.register(request));
  }
  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<BaseResponse<List<Country>>> getCountries() async {
    if (useDummyData) {
      return SuccessResponse(
          CountryDto.dummyList.map((dto) => dto.toEntity()).toList());
    }
    return safeCall(() async {
      final dtos = await _authRemoteDataSource.getCountries();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
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

  @override
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes() async {
    if (useDummyData) {
      return SuccessResponse(
          VehicleTypeDto.dummyList.map((dto) => dto.toEntity()).toList());
    }
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
}

}
