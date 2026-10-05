
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/register_form.dart';

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





class SubmitRegisterIntent extends RegisterIntent {
  final RegisterForm form;
  const SubmitRegisterIntent(this.form);
}
class PickLicensePhotoIntent extends RegisterIntent {
  final ImageSource source;
  const PickLicensePhotoIntent(this.source);
}
class PickIdImageIntent extends RegisterIntent {
  final ImageSource source;
  const PickIdImageIntent(this.source);
}