import 'package:equatable/equatable.dart';

import '../../../../config/resource/resource.dart';
import '../../../auth/domain/entities/vehicle_type_entity.dart';
import '../../domain/entities/driver_profile_entity.dart';

class ProfileState extends Equatable {
  // Screen 1: Profile & Logout Resources
  final Resource<DriverProfileEntity> profileResource;
  final Resource<void> logoutResource;

  // Screen 2: User Edit Form
  final String editFirstName;
  final String editLastName;
  final String editEmail;
  final String editPhone;
  final String editGender;
  final String? editPhotoPath;
  final Resource<void> updateUserResource;

  // Screen 3: Vehicle Edit Form
  final Resource<List<VehicleType>> vehicleTypesResource;
  final VehicleType? selectedVehicleType;
  final String editVehicleNumber;
  final String? editLicensePath;
  final Resource<void> updateVehicleResource;

  const ProfileState({
    required this.profileResource,
    required this.logoutResource,
    required this.editFirstName,
    required this.editLastName,
    required this.editEmail,
    required this.editPhone,
    required this.editGender,
    this.editPhotoPath,
    required this.updateUserResource,
    required this.vehicleTypesResource,
    this.selectedVehicleType,
    required this.editVehicleNumber,
    this.editLicensePath,
    required this.updateVehicleResource,
  });

  factory ProfileState.initial() => const ProfileState(
    profileResource: Resource.initial(),
    logoutResource: Resource.initial(),
    editFirstName: '',
    editLastName: '',
    editEmail: '',
    editPhone: '',
    editGender: 'Male',
    editPhotoPath: null,
    updateUserResource: Resource.initial(),
    vehicleTypesResource: Resource.initial(),
    selectedVehicleType: null,
    editVehicleNumber: '',
    editLicensePath: null,
    updateVehicleResource: Resource.initial(),
  );
  bool get hasUserEditChanged {
    final original = profileResource.data;
    if (original == null) return false;
    final initialGender = original.gender.isEmpty ? 'Male' : original.gender;
    final nameChanged = editFirstName.trim() != original.firstName.trim() ||
        editLastName.trim() != original.lastName.trim();
    final phoneChanged = editPhone.trim() != original.phone.trim();
    final genderChanged = editGender != initialGender;
    final photoChanged = editPhotoPath != null && editPhotoPath!.isNotEmpty;
    return nameChanged || phoneChanged || genderChanged || photoChanged;
  }
  bool get isUserEditValid =>
      editFirstName.trim().isNotEmpty &&
          editLastName.trim().isNotEmpty &&
          editPhone.trim().isNotEmpty&&
          hasUserEditChanged;

  bool get isVehicleEditValid =>
      selectedVehicleType != null &&
          editVehicleNumber.trim().isNotEmpty;


  ProfileState copyWith({
    Resource<DriverProfileEntity>? profileResource,
    Resource<void>? logoutResource,
    String? editFirstName,
    String? editLastName,
    String? editEmail,
    String? editPhone,
    String? editGender,
    String? editPhotoPath,
    Resource<void>? updateUserResource,
    Resource<List<VehicleType>>? vehicleTypesResource,
    VehicleType? selectedVehicleType,
    bool clearSelectedVehicleType = false,
    String? editVehicleNumber,
    String? editLicensePath,
    Resource<void>? updateVehicleResource,
  }) {
    return ProfileState(
      profileResource: profileResource ?? this.profileResource,
      logoutResource: logoutResource ?? this.logoutResource,
      editFirstName: editFirstName ?? this.editFirstName,
      editLastName: editLastName ?? this.editLastName,
      editEmail: editEmail ?? this.editEmail,
      editPhone: editPhone ?? this.editPhone,
      editGender: editGender ?? this.editGender,
      editPhotoPath: editPhotoPath ?? this.editPhotoPath,
      updateUserResource: updateUserResource ?? this.updateUserResource,
      vehicleTypesResource: vehicleTypesResource ?? this.vehicleTypesResource,
      selectedVehicleType: clearSelectedVehicleType
          ? null
          : (selectedVehicleType ?? this.selectedVehicleType),
      editVehicleNumber: editVehicleNumber ?? this.editVehicleNumber,
      editLicensePath: editLicensePath ?? this.editLicensePath,
      updateVehicleResource: updateVehicleResource ?? this.updateVehicleResource,
    );
  }

  @override
  List<Object?> get props => [
    profileResource,
    logoutResource,
    editFirstName,
    editLastName,
    editEmail,
    editPhone,
    editGender,
    editPhotoPath,
    updateUserResource,
    vehicleTypesResource,
    selectedVehicleType,
    editVehicleNumber,
    editLicensePath,
    updateVehicleResource,
  ];
}