import 'package:injectable/injectable.dart';

import '../../../../config/secure_storage/secure_storage.dart';
import '../../data/data_source/local_data_source.dart';

abstract final class _Keys {
  static const token = 'auth_token';
  static const refreshToken = 'auth_refresh_token';
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _Keys.token, value: token);

  @override
  Future<void> saveRefreshToken(String refreshToken) =>
      _secureStorage.write(key: _Keys.refreshToken, value: refreshToken);

  @override
  Future<String?> getToken() => _secureStorage.read(key: _Keys.token);

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _Keys.token);
    await _secureStorage.delete(key: _Keys.refreshToken);
  }
}
