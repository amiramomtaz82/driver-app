import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../repo/profile_repo.dart';

@injectable
class LogoutUseCase {
  final ProfileRepo _profileRepo;

  const LogoutUseCase(this._profileRepo);

  Future<BaseResponse<void>> call() => _profileRepo.logout();
}