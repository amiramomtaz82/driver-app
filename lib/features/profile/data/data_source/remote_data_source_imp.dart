import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../api/profile_api_client.dart';
import '../../data/data_source/remote_data_source.dart';
import '../../data/models/driver_vehicle_dto.dart';

import '../../data/models/update_vehicle_request_dto.dart';
import '../../data/models/user_profile_dto.dart';
import '../models/update_user_profile_request.dart';


@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileClient _client;

  ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<UserProfileDto> getUserProfile() => _client.getUserProfile();

  @override
  Future<UserProfileDto> updateUserProfile(
      UpdateUserProfileRequestDto requestDto,
      ) =>
      _client.updateUserProfile(FormData.fromMap(requestDto.toMap()));

  @override
  Future<DriverVehicleDto> getDriverVehicle() => _client.getDriverVehicle();

  @override
  Future<void> updateDriverVehicle(
      UpdateVehicleRequestDto requestDto,
      ) =>
      _client.updateDriverVehicle(FormData.fromMap(requestDto.toMap()));

  @override
  Future<void> logout() => _client.logout();
}