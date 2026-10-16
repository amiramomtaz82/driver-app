import '../../../../config/base_response/base_response.dart';
import '../entities/driver_profile_entity.dart';
import '../entities/update_user_profile_params.dart';
import '../entities/update_vehicle_params.dart';


abstract interface class ProfileRepo {

  Future<BaseResponse<DriverProfileEntity>> getProfile();


  Future<BaseResponse<DriverProfileEntity>> updateUserProfile(
      UpdateUserProfileParams params,
      );

  Future<BaseResponse<void>> updateVehicle(
      UpdateVehicleParams params,
      );


  Future<BaseResponse<void>> logout();
}