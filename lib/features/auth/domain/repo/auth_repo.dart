import 'package:driver_app/config/base_response/base_response.dart';
import '../models/login_response_model.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<LoginResponseModel>> login({
    required String email,
    required String password,
  });
}