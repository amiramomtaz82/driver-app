import 'package:dio/dio.dart';
import 'package:driver_app/core/constants/endpoints.dart';
import 'package:driver_app/features/auth/data/models/message_response_model.dart';
import 'package:driver_app/features/auth/data/models/verify_otp_response_model.dart';
import 'package:driver_app/features/auth/data/models/country_dto.dart';
import 'package:driver_app/features/auth/data/models/vehicle_type_dto.dart';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/endpoints.dart';
import '../../data/models/register_request_dto.dart';
import '../../data/models/register_response_dto.dart';



part 'auth_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.forgetPassword)
  Future<MessageResponseModel> forgetPassword(@Body() Map<String, dynamic> body);

  @POST(Endpoints.verifyOtp)
  Future<VerifyOtpResponseModel> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(Endpoints.resetPassword)
  Future<MessageResponseModel> resetPassword(@Body() Map<String, dynamic> body);
  @POST(Endpoints.register)
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  @GET(Endpoints.countries)
  Future<List<CountryDto>> getCountries();

  @GET(Endpoints.vehicleTypes)
  Future<List<VehicleTypeDto>> getVehicleTypes();
}