import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../data/models/register_request_dto.dart';
import '../../data/models/register_response_dto.dart';
import '../repo/auth_repo.dart';

@injectable
class RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCase(this._authRepo);


  Future<BaseResponse<RegisterResponseDto>> call(RegisterRequestDto request) async {
    return await _authRepo.register(request);
  }
}