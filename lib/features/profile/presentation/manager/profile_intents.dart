import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entities/vehicle_type_entity.dart';

sealed class ProfileIntent {
  const ProfileIntent();
}

// --- Screen 1: Profile Main Intents ---
sealed class ProfileMainIntent extends ProfileIntent {
  const ProfileMainIntent();
}

class ProfileStarted extends ProfileMainIntent {
  const ProfileStarted();
}

class ProfileRefreshed extends ProfileMainIntent {
  const ProfileRefreshed();
}

class LogoutConfirmed extends ProfileMainIntent {
  const LogoutConfirmed();
}

// --- Screen 2: Edit User Profile Intents ---
sealed class UserEditIntent extends ProfileIntent {
  const UserEditIntent();
}

class InitUserEditForm extends UserEditIntent {
  const InitUserEditForm();
}

class FirstNameChanged extends UserEditIntent {
  final String value;
  const FirstNameChanged(this.value);
}

class LastNameChanged extends UserEditIntent {
  final String value;
  const LastNameChanged(this.value);
}

class PhoneChanged extends UserEditIntent {
  final String value;
  const PhoneChanged(this.value);
}

class GenderChanged extends UserEditIntent {
  final String value;
  const GenderChanged(this.value);
}

class PickUserPhotoIntent extends UserEditIntent {
  final ImageSource source;
  const PickUserPhotoIntent(this.source);
}

class SubmitUserEdit extends UserEditIntent {
  const SubmitUserEdit();
}

// --- Screen 3: Edit Vehicle Intents ---
sealed class VehicleEditIntent extends ProfileIntent {
  const VehicleEditIntent();
}

class InitVehicleEditForm extends VehicleEditIntent {
  const InitVehicleEditForm();
}

class VehicleTypeSelected extends VehicleEditIntent {
  final VehicleType type;
  const VehicleTypeSelected(this.type);
}

class VehicleNumberChanged extends VehicleEditIntent {
  final String number;
  const VehicleNumberChanged(this.number);
}

class PickVehicleLicenseIntent extends VehicleEditIntent {
  final ImageSource source;
  const PickVehicleLicenseIntent(this.source);
}

class SubmitVehicleEdit extends VehicleEditIntent {
  const SubmitVehicleEdit();
}