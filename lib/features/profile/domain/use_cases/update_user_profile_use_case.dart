import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../entities/driver_profile_entity.dart';
import '../entities/update_user_profile_params.dart';
import '../repo/profile_repo.dart';

@injectable
class UpdateUserProfileUseCase {
  final ProfileRepo _profileRepo;

  const UpdateUserProfileUseCase(this._profileRepo);

  Future<BaseResponse<DriverProfileEntity>> call(
      UpdateUserProfileParams params,
      ) =>
      _profileRepo.updateUserProfile(params);
}