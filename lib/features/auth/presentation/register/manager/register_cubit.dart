import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/resource/resource.dart';

import '../../../../../core/go_routes/routes_names.dart';
import '../../../data/models/register_request_dto.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
import '../../../domain/use_cases/get_countries_use_case.dart';
import '../../../domain/use_cases/get_vehicle_type_use_case.dart';
import '../../../domain/use_cases/register_use_case.dart';
import 'register_intents.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends BaseCubit<RegisterState, UiEvent> {
  final RegisterUseCase _registerUseCase;
  final GetCountriesUseCase _getCountriesUseCase;
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;

  RegisterCubit(
      this._registerUseCase,
      this._getCountriesUseCase,
      this._getVehicleTypesUseCase,
      ) : super(const RegisterState()) {
    onIntent(const LoadDropdownDataIntent());
  }

  void onIntent(RegisterIntent intent) {
    switch (intent) {
      case LoadDropdownDataIntent():
        _loadDropdownData();
      case SelectCountryIntent(:final country):
        emit(state.copyWith(selectedCountry: country));
      case SelectVehicleTypeIntent(:final vehicleType):
        emit(state.copyWith(selectedVehicleType: vehicleType));
      case SelectGenderIntent(:final gender):
        emit(state.copyWith(gender: gender));
      case TogglePasswordVisibilityIntent():
        emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
      case ToggleConfirmPasswordVisibilityIntent():
        emit(state.copyWith(isConfirmPasswordHidden: !state.isConfirmPasswordHidden));
      case SetLicensePhotoIntent(:final path):
        emit(state.copyWith(licensePhotoPath: path));
      case SetIdImageIntent(:final path):
        emit(state.copyWith(idImagePath: path));
      case SubmitRegisterIntent(:final request):
        _submitRegister(request);
    }
  }

  Future<void> _loadDropdownData() async {
    // 1. Fetch Countries
    emit(state.copyWith(countriesResource: const Resource.loading()));
    final countriesResult = await _getCountriesUseCase();

    switch (countriesResult) {
      case SuccessResponse<List<Country>>(:final data):
        emit(state.copyWith(
          countriesResource: Resource.success(data),
          selectedCountry: data.isNotEmpty ? data.first : null,
        ));
      case ErrorResponse<List<Country>>(:final errMessage):
        emit(state.copyWith(countriesResource: Resource.error(errMessage)));
    }

    // 2. Fetch Vehicle Types
    emit(state.copyWith(vehicleTypesResource: const Resource.loading()));
    final vehiclesResult = await _getVehicleTypesUseCase();

    switch (vehiclesResult) {
      case SuccessResponse<List<VehicleType>>(:final data):
        emit(state.copyWith(
          vehicleTypesResource: Resource.success(data),
          selectedVehicleType: data.isNotEmpty ? data.first : null,
        ));
      case ErrorResponse<List<VehicleType>>(:final errMessage):
        emit(state.copyWith(vehicleTypesResource: Resource.error(errMessage)));
    }
  }

  Future<void> _submitRegister(RegisterRequestDto request) async {
    emit(state.copyWith(registerResource: const Resource.loading()));

    final result = await _registerUseCase(request);

    switch (result) {
      case SuccessResponse(:final data):
        emit(state.copyWith(registerResource: Resource.success(data)));
        emitEvent(const NavigateReplacementEvent(AppRoutes.registrationSuccess));

      case ErrorResponse(:final errMessage):
        emit(state.copyWith(registerResource: Resource.error(errMessage)));
    
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }
}