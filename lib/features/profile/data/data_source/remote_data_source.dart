import '../models/driver_vehicle_dto.dart';

import '../models/update_user_profile_request.dart';
import '../models/update_vehicle_request_dto.dart';
import '../models/user_profile_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileDto> getUserProfile();

  Future<UserProfileDto> updateUserProfile(
      UpdateUserProfileRequestDto requestDto,
      );

  Future<DriverVehicleDto> getDriverVehicle();

  Future<void> updateDriverVehicle(
      UpdateVehicleRequestDto requestDto,
      );

  Future<void> logout();
}