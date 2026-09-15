import 'package:injectable/injectable.dart';

import '../../data/data_source/remote_data_source.dart';
import '../client/auth_client.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);}