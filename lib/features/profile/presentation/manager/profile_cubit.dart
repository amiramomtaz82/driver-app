import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base/base_cubit.dart';
import '../../../../config/base/ui_events.dart';
import '../../../../config/base_response/base_response.dart';
import '../../../../config/resource/resource.dart';
import '../../../../core/go_routes/routes_names.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/domain/entities/vehicle_type_entity.dart';
import '../../../auth/domain/use_cases/get_vehicle_type_use_case.dart';
import '../../domain/entities/driver_vehicle_entity.dart';
import '../../domain/entities/update_user_profile_params.dart';
import '../../domain/entities/update_vehicle_params.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';
import '../../domain/use_cases/update_vehicle_use_case.dart';
import 'profile_intents.dart';
import 'profile_state.dart';

@lazySingleton
class ProfileCubit extends BaseCubit<ProfileState, UiEvent> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UpdateVehicleUseCase _updateVehicleUseCase;
  final GetVehicleTypesUseCase _getVehicleTypeUseCase;
  final LogoutUseCase _logoutUseCase;
  final ImagePickerService _imagePickerService;

  ProfileCubit(
      this._getProfileUseCase,
      this._updateUserProfileUseCase,
      this._updateVehicleUseCase,
      this._getVehicleTypeUseCase,
      this._logoutUseCase,
      this._imagePickerService,
      ) : super(ProfileState.initial());

  void onIntent(ProfileIntent intent) {
    switch (intent) {
      case ProfileMainIntent():
        _handleProfileMain(intent);
      case UserEditIntent():
        _handleUserEdit(intent);
      case VehicleEditIntent():
        _handleVehicleEdit(intent);
    }
  }

  void _handleProfileMain(ProfileMainIntent intent) {
    switch (intent) {
      case ProfileStarted():
      case ProfileRefreshed():
        _loadProfile();
      case LogoutConfirmed():
        _logout();
    }
  }

  void _handleUserEdit(UserEditIntent intent) {
    switch (intent) {
      case InitUserEditForm():
        _initUserEditForm();
      case FirstNameChanged(:final value):
        emit(state.copyWith(editFirstName: value));
      case LastNameChanged(:final value):
        emit(state.copyWith(editLastName: value));
      case PhoneChanged(:final value):
        emit(state.copyWith(editPhone: value));
      case GenderChanged(:final value):
        emit(state.copyWith(editGender: value));
      case PickUserPhotoIntent(:final source):
        _pickUserPhoto(source);
      case SubmitUserEdit():
        _submitUserEdit();
    }
  }

  void _handleVehicleEdit(VehicleEditIntent intent) {
    switch (intent) {
      case InitVehicleEditForm():
        _initVehicleEditForm();
      case VehicleTypeSelected(:final type):
        emit(state.copyWith(selectedVehicleType: type));
      case VehicleNumberChanged(:final number):
        emit(state.copyWith(editVehicleNumber: number));
      case PickVehicleLicenseIntent(:final source):
        _pickVehicleLicense(source);
      case SubmitVehicleEdit():
        _submitVehicleEdit();
    }
  }

  Future<void> _loadProfile() async {
    emit(state.copyWith(profileResource: const Resource.loading()));
    final response = await _getProfileUseCase();
    switch (response) {
      case SuccessResponse(:final data):
        emit(state.copyWith(profileResource: Resource.success(data)));
      case ErrorResponse(:final errMessage):
        emit(state.copyWith(profileResource: Resource.error(errMessage)));
    }
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutResource: const Resource.loading()));
    await _logoutUseCase();
    emit(state.copyWith(logoutResource: const Resource.initial()));
    emitEvent(const NavigateReplacementEvent(AppRoutes.login));
  }

  void _initUserEditForm() {
    final user = state.profileResource.data;
    if (user == null) return;
    emit(state.copyWith(
      editFirstName: user.firstName,
      editLastName: user.lastName,
      editEmail: user.email,
      editPhone: user.phone,
      editGender: user.gender.isEmpty ? 'Male' : user.gender,
      editPhotoPath: null,
      updateUserResource: const Resource.initial(),
    ));
  }

  Future<void> _pickUserPhoto(ImageSource source) async {
    final path = source == ImageSource.camera
        ? await _imagePickerService.pickImageFromCamera()
        : await _imagePickerService.pickImageFromGallery();
    if (path != null) emit(state.copyWith(editPhotoPath: path));
  }

  Future<void> _submitUserEdit() async {
    if (!state.isUserEditValid || state.updateUserResource.isLoading) return;
    emit(state.copyWith(updateUserResource: const Resource.loading()));

    final params = UpdateUserProfileParams(
      fullName: '${state.editFirstName.trim()} ${state.editLastName.trim()}',
      email: state.editEmail,
      phone: state.editPhone.trim(),
      gender: state.editGender,
      photoFilePath: state.editPhotoPath,
    );

    final response = await _updateUserProfileUseCase(params);
    _handleUserEditResponse(response);
  }

  void _handleUserEditResponse(BaseResponse<dynamic> response) {
    switch (response) {
      case SuccessResponse():
        final current = state.profileResource.data;
        final updated = current?.copyWith(
          fullName: '${state.editFirstName.trim()} ${state.editLastName.trim()}',
          phone: state.editPhone.trim(),
          gender: state.editGender,
          photoUrl: state.editPhotoPath ?? current.photoUrl,
        );
        emit(state.copyWith(
          profileResource: Resource.success(updated),
          updateUserResource: const Resource.success(null),
        ));
        emitEvent(const ShowSnackBarEvent(
          message: LocaleKeys.profile_user_update_success,
          isError: false,
        ));
        emitEvent(const PopEvent(true));
      case ErrorResponse(:final errMessage):
        emit(state.copyWith(updateUserResource: Resource.error(errMessage)));
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }

  Future<void> _initVehicleEditForm() async {
    final vehicle = state.profileResource.data?.vehicle;
    emit(state.copyWith(
      editVehicleNumber: vehicle?.vehicleNumber ?? '',
      editLicensePath: vehicle?.licensePhotoUrl,
      clearSelectedVehicleType: true,
      vehicleTypesResource: const Resource.loading(),
      updateVehicleResource: const Resource.initial(),
    ));
    final response = await _getVehicleTypeUseCase();
    _handleVehicleTypesResponse(response, vehicle?.vehicleType);
  }

  void _handleVehicleTypesResponse(
      BaseResponse<List<VehicleType>> res,
      String? currentType,
      ) {
    switch (res) {
      case SuccessResponse(:final data):
        final match = data.where(
              (v) => v.name.toLowerCase() == currentType?.toLowerCase(),
        );
        emit(state.copyWith(
          vehicleTypesResource: Resource.success(data),
          selectedVehicleType: match.isNotEmpty
              ? match.first
              : (data.isNotEmpty ? data.first : null),
        ));

      case ErrorResponse(:final errMessage):
        emit(state.copyWith(
          vehicleTypesResource: Resource.error(errMessage),
          clearSelectedVehicleType: true,
        ));
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }

  Future<void> _pickVehicleLicense(ImageSource source) async {
    final path = source == ImageSource.camera
        ? await _imagePickerService.pickImageFromCamera()
        : await _imagePickerService.pickImageFromGallery();
    if (path != null) emit(state.copyWith(editLicensePath: path));
  }

  Future<void> _submitVehicleEdit() async {
    if (!state.isVehicleEditValid || state.updateVehicleResource.isLoading) return;
    emit(state.copyWith(updateVehicleResource: const Resource.loading()));

    final params = UpdateVehicleParams(
      vehicleType: state.selectedVehicleType!.id,
      vehicleNumber: state.editVehicleNumber.trim(),
      licenseFilePath: state.editLicensePath,
    );

    final response = await _updateVehicleUseCase(params);
    _handleVehicleEditResponse(response);
  }

  void _handleVehicleEditResponse(BaseResponse<dynamic> response) {
    switch (response) {
      case SuccessResponse():
        final updated = state.profileResource.data?.copyWith(
          vehicle: DriverVehicleEntity(
            vehicleType: state.selectedVehicleType!.name,
            vehicleNumber: state.editVehicleNumber.trim(),
            licensePhotoUrl: state.editLicensePath,
          ),
        );
        emit(state.copyWith(
          profileResource: Resource.success(updated),
          updateVehicleResource: const Resource.success(null),
        ));
        emitEvent(const ShowSnackBarEvent(
          message: LocaleKeys.profile_update_success,
          isError: false,
        ));
        emitEvent(const PopEvent(true));
      case ErrorResponse(:final errMessage):
        emit(state.copyWith(updateVehicleResource: Resource.error(errMessage)));
        emitEvent(ShowSnackBarEvent(message: errMessage, isError: true));
    }
  }
}