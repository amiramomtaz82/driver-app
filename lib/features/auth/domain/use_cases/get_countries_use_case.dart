import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/country.dart';
import '../repo/auth_repo.dart';

@injectable
class GetCountriesUseCase {
  final AuthRepo _authRepo;

  GetCountriesUseCase(this._authRepo);

  Future<BaseResponse<List<Country>>> call() {
    return _authRepo.getCountries();
  }
}