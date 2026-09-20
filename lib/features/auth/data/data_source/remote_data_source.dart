import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}
