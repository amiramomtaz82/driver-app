import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String? currentPasswordError;
  final Resource<AuthMessageEntity> changePasswordResource;

  const ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.currentPasswordError,
    this.changePasswordResource = const Resource.initial(),
  });

  bool get isFormValid =>
      currentPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      confirmPassword.isNotEmpty;

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? currentPasswordError,
    bool clearCurrentPasswordError = false,
    Resource<AuthMessageEntity>? changePasswordResource,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      currentPasswordError: clearCurrentPasswordError
          ? null
          : (currentPasswordError ?? this.currentPasswordError),
      changePasswordResource:
          changePasswordResource ?? this.changePasswordResource,
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        confirmPassword,
        currentPasswordError,
        changePasswordResource,
      ];
}
