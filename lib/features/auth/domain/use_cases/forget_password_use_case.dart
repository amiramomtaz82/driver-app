import 'package:driver_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/auth_message_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepo _authRepo;

  ForgetPasswordUseCase(this._authRepo);

  Future<BaseResponse<AuthMessageEntity>> call({required String email}) {
    return _authRepo.forgetPassword(email: email);
  }
}
