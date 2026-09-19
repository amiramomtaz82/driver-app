import 'package:dio/dio.dart';
import 'package:driver_app/core/constants/endpoints.dart';
import 'package:driver_app/features/auth/data/models/message_response_model.dart';
import 'package:driver_app/features/auth/data/models/verify_otp_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

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
}
