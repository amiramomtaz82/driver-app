import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/resource/resource.dart';

import '../../../../../core/go_routes/routes_names.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/register_form.dart';
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
  final ImagePickerService _imagePickerService;

  RegisterCubit(
      this._registerUseCase,
      this._getCountriesUseCase,
      this._getVehicleTypesUseCase,
      this._imagePickerService,
      ) : super(const RegisterState());

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
      case PickLicensePhotoIntent(:final source):
        _pickLicensePhoto(source);
      case PickIdImageIntent(:final source):
        _pickIdImage(source);
      case SubmitRegisterIntent(:final form):
        _submitRegister(form);
    }
  }

  Future<void> _loadCountries() async {
    emit(state.copyWith(countriesResource: const Resource.loading()));

    final result = await _getCountriesUseCase();

    switch (result) {
      case SuccessResponse<List<Country>>(:final data):
        emit(state.copyWith(
          countriesResource: Resource.success(data),
          selectedCountry: data.isNotEmpty ? data.first : null,
        ));
      case ErrorResponse<List<Country>>(:final errMessage):
        emit(state.copyWith(countriesResource: Resource.error(errMessage)));
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }

  Future<void> _loadVehicleTypes() async {
    emit(state.copyWith(vehicleTypesResource: const Resource.loading()));

    final result = await _getVehicleTypesUseCase();

    switch (result) {
      case SuccessResponse<List<VehicleType>>(:final data):
        emit(state.copyWith(
          vehicleTypesResource: Resource.success(data),
          selectedVehicleType: data.isNotEmpty ? data.first : null,
        ));
      case ErrorResponse<List<VehicleType>>(:final errMessage):
        emit(state.copyWith(vehicleTypesResource: Resource.error(errMessage)));
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }

  Future<void> _loadDropdownData() async {
    await Future.wait([
      _loadCountries(),
      _loadVehicleTypes(),
    ]);
  }
  Future<void> _submitRegister(RegisterForm  form) async {
    emit(state.copyWith(registerResource: const Resource.loading()));

    final result = await _registerUseCase(form);

    switch (result) {
      case SuccessResponse(:final data):
        emit(state.copyWith(registerResource: Resource.success(data)));
        emitEvent(const NavigateReplacementEvent(AppRoutes.registrationSuccess));

      case ErrorResponse(:final errMessage):
        emit(state.copyWith(registerResource: Resource.error(errMessage)));
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }
  Future<void> _pickLicensePhoto(ImageSource source) async {
    final path = source == ImageSource.camera
        ? await _imagePickerService.pickImageFromCamera()
        : await _imagePickerService.pickImageFromGallery();
    if (path != null) {
      emit(state.copyWith(licensePhotoPath: path));
    }
  }
  Future<void> _pickIdImage(ImageSource source) async {
    final path = source == ImageSource.camera
        ? await _imagePickerService.pickImageFromCamera()
        : await _imagePickerService.pickImageFromGallery();
    if (path != null) {
      emit(state.copyWith(idImagePath: path));
    }
  }
}