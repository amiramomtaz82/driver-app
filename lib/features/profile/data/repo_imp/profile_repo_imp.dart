import '../../../../config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/safe_call.dart';
import '../../../../config/secure_storage/secure_storage.dart';
import '../../domain/entities/driver_profile_entity.dart';
import '../../domain/entities/update_user_profile_params.dart';
import '../../domain/entities/update_vehicle_params.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_source/remote_data_source.dart';
import '../models/update_user_profile_request.dart';
import '../models/update_vehicle_request_dto.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  ProfileRepoImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<BaseResponse<DriverProfileEntity>> getProfile() async {
    return safeCall(() async {
      final userProfileDto = await _remoteDataSource.getUserProfile();
      final vehicleDto = await _remoteDataSource.getDriverVehicle();

      return userProfileDto.toEntity().copyWith(
        vehicle: vehicleDto.toEntity(),
      );
    });
  }

  @override
  Future<BaseResponse<DriverProfileEntity>> updateUserProfile(
      UpdateUserProfileParams params,
      ) async {
    return safeCall(() async {
      final requestDto = await UpdateUserProfileRequestDto.fromParams(params);
      final responseDto = await _remoteDataSource.updateUserProfile(requestDto);
      return responseDto.toEntity();
    });
  }

  @override
  Future<BaseResponse<void>> updateVehicle(
      UpdateVehicleParams params,
      ) async {
    return safeCall(() async {
      final requestDto = await UpdateVehicleRequestDto.fromParams(params);
      await _remoteDataSource.updateDriverVehicle(requestDto);
    });
  }

  @override
  Future<BaseResponse<void>> logout() async {
    return safeCall(() async {
      try {
        await _remoteDataSource.logout();
      } finally {
        await _secureStorage.deleteAll();
      }
    });
  }
}