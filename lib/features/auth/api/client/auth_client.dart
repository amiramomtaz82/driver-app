import 'package:dio/dio.dart';
import 'package:driver_app/core/constants/endpoints.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.loginEndPoint)
  Future<LoginResponseModel> login(@Body() Map<String, dynamic> body);
}