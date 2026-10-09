import 'package:equatable/equatable.dart';
import '../../../../../config/resource/resource.dart';
import '../../../data/models/register_response_dto.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
class RegisterState extends Equatable {
  final Resource<List<Country>> countriesResource;
  final Resource<List<VehicleType>> vehicleTypesResource;
  final Resource<RegisterResponseDto> registerResource;
  final Country? selectedCountry;
  final VehicleType? selectedVehicleType;
  final String gender; 
  final String? licensePhotoPath;
  final String? idImagePath;
  final bool isPasswordHidden;
  final bool isConfirmPasswordHidden;
  const RegisterState({
    this.countriesResource = const Resource.initial(),
    this.vehicleTypesResource = const Resource.initial(),
    this.registerResource = const Resource.initial(),
    this.selectedCountry,
    this.selectedVehicleType,
    this.gender = 'male',
    this.licensePhotoPath,
    this.idImagePath,
    this.isPasswordHidden = true,
    this.isConfirmPasswordHidden = true,
  });
  RegisterState copyWith({
    Resource<List<Country>>? countriesResource,
    Resource<List<VehicleType>>? vehicleTypesResource,
    Resource<RegisterResponseDto>? registerResource,
    Country? selectedCountry,
    VehicleType? selectedVehicleType,
    String? gender,
    String? licensePhotoPath,
    String? idImagePath,
    bool? isPasswordHidden,
    bool? isConfirmPasswordHidden,
  }) {
    return RegisterState(
      countriesResource: countriesResource ?? this.countriesResource,
      vehicleTypesResource: vehicleTypesResource ?? this.vehicleTypesResource,
      registerResource: registerResource ?? this.registerResource,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      gender: gender ?? this.gender,
      licensePhotoPath: licensePhotoPath ?? this.licensePhotoPath,
      idImagePath: idImagePath ?? this.idImagePath,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isConfirmPasswordHidden: isConfirmPasswordHidden ?? this.isConfirmPasswordHidden,
    );
  }
  @override
  List<Object?> get props => [
    countriesResource,
    vehicleTypesResource,
    registerResource,
    selectedCountry,
    selectedVehicleType,
    gender,
    licensePhotoPath,
    idImagePath,
    isPasswordHidden,
    isConfirmPasswordHidden,
  ];
}