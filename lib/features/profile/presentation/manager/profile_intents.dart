import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/domain/entities/vehicle_type_entity.dart';

sealed class ProfileIntent extends Equatable {
  const ProfileIntent();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [value];
}

class LastNameChanged extends UserEditIntent {
  final String value;
  const LastNameChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class PhoneChanged extends UserEditIntent {
  final String value;
  const PhoneChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class GenderChanged extends UserEditIntent {
  final String value;
  const GenderChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class PickUserPhotoIntent extends UserEditIntent {
  final ImageSource source;
  const PickUserPhotoIntent(this.source);

  @override
  List<Object?> get props => [source];
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

  @override
  List<Object?> get props => [type];
}

class VehicleNumberChanged extends VehicleEditIntent {
  final String number;
  const VehicleNumberChanged(this.number);

  @override
  List<Object?> get props => [number];
}

class PickVehicleLicenseIntent extends VehicleEditIntent {
  final ImageSource source;
  const PickVehicleLicenseIntent(this.source);

  @override
  List<Object?> get props => [source];
}

class SubmitVehicleEdit extends VehicleEditIntent {
  const SubmitVehicleEdit();
}