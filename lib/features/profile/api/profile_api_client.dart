import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/endpoints.dart';
import '../data/models/driver_vehicle_dto.dart';
import '../data/models/user_profile_dto.dart';

part 'profile_api_client.g.dart';

@singleton
@RestApi()
abstract class ProfileClient {
  @factoryMethod
  factory ProfileClient(Dio dio) = _ProfileClient;

  @GET(Endpoints.getUserProfile)
  Future<UserProfileDto> getUserProfile();

  @PUT(Endpoints.updateUserProfile)
  @MultiPart()
  Future<UserProfileDto> updateUserProfile(
      @PartMap() Map<String, dynamic> parts,
      );

  @GET(Endpoints.getDriverVehicle)
  Future<DriverVehicleDto> getDriverVehicle();

  @PATCH(Endpoints.updateDriverVehicle)
  @MultiPart()
  Future<void> updateDriverVehicle(
      @PartMap() Map<String, dynamic> parts,
      );

  @POST(Endpoints.logout)
  Future<void> logout();
}