import '../models/country_dto.dart';
import '../models/register_request_dto.dart';
import '../models/register_response_dto.dart';
import '../models/vehicle_type_dto.dart';
import '../models/message_response_model.dart';
import '../models/verify_otp_response_model.dart';
abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseDto> register(RegisterRequestDto request);
  Future<List<CountryDto>> getCountries();
  Future<List<VehicleTypeDto>> getVehicleTypes();



  Future<MessageResponseModel> forgetPassword({required String email});

  Future<VerifyOtpResponseData> verifyOtp({
    required String email,
    required String otpCode,
  });

  Future<MessageResponseModel> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  });
}

import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}
