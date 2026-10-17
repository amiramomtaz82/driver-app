import 'package:driver_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/auth_message_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class ChangePasswordUseCase {
  final AuthRepo _authRepo;

  ChangePasswordUseCase(this._authRepo);

  Future<BaseResponse<AuthMessageEntity>> call({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return _authRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}
