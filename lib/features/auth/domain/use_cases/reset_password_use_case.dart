import 'package:driver_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/auth_message_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepo _authRepo;

  ResetPasswordUseCase(this._authRepo);

  Future<BaseResponse<AuthMessageEntity>> call({
    required String resetToken,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _authRepo.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
