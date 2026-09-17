import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';

import '../entities/vehicle_type_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class GetVehicleTypesUseCase {
  final AuthRepo _authRepo;

  GetVehicleTypesUseCase(this._authRepo);

  Future<BaseResponse<List<VehicleType>>> call() {
    return _authRepo.getVehicleTypes();
  }
}