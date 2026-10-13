import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/update_vehicle_params.dart';
import '../repo/profile_repo.dart';

@injectable
class UpdateVehicleUseCase {
  final ProfileRepo _profileRepo;

  const UpdateVehicleUseCase(this._profileRepo);

  Future<BaseResponse<void>> call(UpdateVehicleParams params) =>
      _profileRepo.updateVehicle(params);
}