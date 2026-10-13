import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';

import '../entities/driver_profile_entity.dart';
import '../repo/profile_repo.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepo _profileRepo;

  const GetProfileUseCase(this._profileRepo);

  Future<BaseResponse<DriverProfileEntity>> call() => _profileRepo.getProfile();
}