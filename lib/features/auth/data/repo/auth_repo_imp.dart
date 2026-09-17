import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../config/base_response/safe_call.dart';
import '../../domain/entities/country.dart';

import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/repo/auth_repo.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../models/country_dto.dart';
import '../models/register_request_dto.dart';
import '../models/register_response_dto.dart';
import '../models/vehicle_type_dto.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(
      this._authRemoteDataSource,
      this._authLocalDataSource,
      );

  // Toggle: change to false when backend endpoints are ready!
  static const bool useDummyData = true;

  @override
  Future<BaseResponse<RegisterResponseDto>> register(RegisterRequestDto request) {
    return safeCall(() => _authRemoteDataSource.register(request));
  }

  @override
  Future<BaseResponse<List<Country>>> getCountries() async {
    if (useDummyData) {
      return SuccessResponse(CountryDto.dummyList.map((dto) => dto.toEntity()).toList());
    }
    return safeCall(() async {
      final dtos = await _authRemoteDataSource.getCountries();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<BaseResponse<List<VehicleType>>> getVehicleTypes() async {
    if (useDummyData) {
      return SuccessResponse(VehicleTypeDto.dummyList.map((dto) => dto.toEntity()).toList());
    }
    return safeCall(() async {
      final dtos = await _authRemoteDataSource.getVehicleTypes();
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }
}