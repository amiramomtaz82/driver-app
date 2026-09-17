import 'package:injectable/injectable.dart';
import '../../data/data_source/remote_data_source.dart';
import '../../data/models/country_dto.dart';
import '../../data/models/register_request_dto.dart';
import '../../data/models/register_response_dto.dart';
import '../../data/models/vehicle_type_dto.dart';
import '../client/auth_client.dart';
@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<RegisterResponseDto> register(RegisterRequestDto request) {
    return _authApiClient.register(request);
  }

  @override
  Future<List<CountryDto>> getCountries() {
    return _authApiClient.getCountries();
  }

  @override
  Future<List<VehicleTypeDto>> getVehicleTypes() {
    return _authApiClient.getVehicleTypes();
  }
}