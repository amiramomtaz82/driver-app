import '../../domain/models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}