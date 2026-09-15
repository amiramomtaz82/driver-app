import 'package:injectable/injectable.dart';

import '../../../../config/secure_storage/secure_storage.dart';
import '../../data/data_source/local_data_source.dart';

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);}