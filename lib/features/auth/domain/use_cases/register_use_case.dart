import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../entities/register_response_entity.dart';
import '../entities/register_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCase(this._authRepo);

  Future<BaseResponse<RegisterEntityResponse>> call(RegisterEntity params) {
    return _authRepo.register(params);
  }
}