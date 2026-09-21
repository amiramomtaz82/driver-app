import 'package:injectable/injectable.dart';

import '../../data/data_source/remote_data_source.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';
import '../client/auth_client.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) {
    return _authApiClient.login(request.toJson());
  }
}
