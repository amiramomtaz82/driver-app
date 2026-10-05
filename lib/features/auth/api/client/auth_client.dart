import 'package:dio/dio.dart';
import 'package:driver_app/features/auth/data/models/country_dto.dart';
import 'package:driver_app/features/auth/data/models/vehicle_type_dto.dart';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/endpoints.dart';
import '../../data/models/register_response_dto.dart';
import '../../domain/models/login_response_model.dart';



part 'auth_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.loginEndPoint)
  Future<LoginResponseModel> login(@Body() Map<String, dynamic> body);
  @POST(Endpoints.register)
  @MultiPart()
  Future<RegisterResponseDto> register(@PartMap() Map<String, dynamic> request);


  @GET(Endpoints.countries)
  Future<List<CountryDto>> getCountries();

  @GET(Endpoints.vehicleTypes)
  Future<List<VehicleTypeDto>> getVehicleTypes();
}
