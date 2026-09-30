import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/resource/resource.dart';

import '../../../../../core/go_routes/routes_names.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
import '../../../domain/use_cases/get_countries_use_case.dart';
import '../../../domain/use_cases/get_vehicle_type_use_case.dart';
import '../../../domain/use_cases/register_use_case.dart';
import '../models/register_form.dart';
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

  Future<void> _loadDropdownData() async {
    // 1. Set both resources to loading simultaneously
    emit(state.copyWith(
      countriesResource: const Resource.loading(),
      vehicleTypesResource: const Resource.loading(),
    ));

    // 2. Fetch both in parallel
    final results = await Future.wait([
      _getCountriesUseCase(),
      _getVehicleTypesUseCase(),
    ]);

    final countriesResult = results[0] as BaseResponse<List<Country>>;
    final vehiclesResult = results[1] as BaseResponse<List<VehicleType>>;

    // 3. Handle Countries Result
    Country? selectedCountry;
    final Resource<List<Country>> countriesResource;
    switch (countriesResult) {
      case SuccessResponse<List<Country>>(:final data):
        countriesResource = Resource.success(data);
        selectedCountry = data.isNotEmpty ? data.first : null;
      case ErrorResponse<List<Country>>(:final errMessage):
        countriesResource = Resource.error(errMessage);
    }

    // 4. Handle Vehicle Types Result
    VehicleType? selectedVehicleType;
    final Resource<List<VehicleType>> vehicleTypesResource;
    switch (vehiclesResult) {
      case SuccessResponse<List<VehicleType>>(:final data):
        vehicleTypesResource = Resource.success(data);
        selectedVehicleType = data.isNotEmpty ? data.first : null;
      case ErrorResponse<List<VehicleType>>(:final errMessage):
        vehicleTypesResource = Resource.error(errMessage);
    }

    // 5. (Optional) Combined Error Notification
    if (countriesResult is ErrorResponse || vehiclesResult is ErrorResponse) {
      final errorMessage = countriesResult is ErrorResponse
          ? (countriesResult as ErrorResponse).errMessage
          : (vehiclesResult as ErrorResponse).errMessage;
      emitEvent(ShowSnackBarEvent(message: errorMessage, isError: true));
    }

    // 6. Emit combined final state in a single transition
    emit(state.copyWith(
      countriesResource: countriesResource,
      selectedCountry: selectedCountry,
      vehicleTypesResource: vehicleTypesResource,
      selectedVehicleType: selectedVehicleType,
    ));
  }
  Future<void> _submitRegister(RegisterEntity  form) async {
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