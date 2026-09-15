import 'package:injectable/injectable.dart';

import '../../domain/repo/auth_repo.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(
  this._authRemoteDataSource,
  this._authLocalDataSource);

  }