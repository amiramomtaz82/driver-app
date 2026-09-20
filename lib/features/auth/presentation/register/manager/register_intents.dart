
import '../../../data/models/register_request_dto.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/vehicle_type_entity.dart';

sealed class RegisterIntent {
  const RegisterIntent();
}

class LoadDropdownDataIntent extends RegisterIntent {
  const LoadDropdownDataIntent();
}

class SelectCountryIntent extends RegisterIntent {
  final Country country;
  const SelectCountryIntent(this.country);
}

class SelectVehicleTypeIntent extends RegisterIntent {
  final VehicleType vehicleType;
  const SelectVehicleTypeIntent(this.vehicleType);
}

class SelectGenderIntent extends RegisterIntent {
  final String gender;
  const SelectGenderIntent(this.gender);
}

class TogglePasswordVisibilityIntent extends RegisterIntent {
  const TogglePasswordVisibilityIntent();
}

class ToggleConfirmPasswordVisibilityIntent extends RegisterIntent {
  const ToggleConfirmPasswordVisibilityIntent();
}

class SetLicensePhotoIntent extends RegisterIntent {
  final String path;
  const SetLicensePhotoIntent(this.path);
}

class SetIdImageIntent extends RegisterIntent {
  final String path;
  const SetIdImageIntent(this.path);
}

class SubmitRegisterIntent extends RegisterIntent {
  final RegisterRequestDto request;
  const SubmitRegisterIntent(this.request);
}