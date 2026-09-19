import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/entities/reset_token_entity.dart';
import 'package:equatable/equatable.dart';

enum ForgetPasswordStep { email, otp, resetPassword }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStep step;
  final String email;
  final String newPassword;
  final String confirmPassword;
  final int resendCooldown;
  final Resource<AuthMessageEntity> sendCodeResource;
  final Resource<ResetToken> verifyOtpResource;
  final Resource<AuthMessageEntity> resetPasswordResource;

  const ForgetPasswordState({
    this.step = ForgetPasswordStep.email,
    this.email = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.resendCooldown = 0,
    this.sendCodeResource = const Resource.initial(),
    this.verifyOtpResource = const Resource.initial(),
    this.resetPasswordResource = const Resource.initial(),
  });

  bool get isEmailValid => email.isNotEmpty;

  bool get isResetFormValid =>
      newPassword.isNotEmpty && confirmPassword.isNotEmpty;

  bool get canResend => resendCooldown == 0 && !sendCodeResource.isLoading;

  /// The reset token is only kept while the OTP verification succeeded.
  ResetToken? get resetToken => verifyOtpResource.data;

  /// The inline error under the OTP boxes — only while the verify step failed.
  String? get otpErrorMessage =>
      verifyOtpResource.isError ? verifyOtpResource.errorMessage : null;

  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    String? email,
    String? newPassword,
    String? confirmPassword,
    int? resendCooldown,
    Resource<AuthMessageEntity>? sendCodeResource,
    Resource<ResetToken>? verifyOtpResource,
    Resource<AuthMessageEntity>? resetPasswordResource,
  }) {
    return ForgetPasswordState(
      step: step ?? this.step,
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      resendCooldown: resendCooldown ?? this.resendCooldown,
      sendCodeResource: sendCodeResource ?? this.sendCodeResource,
      verifyOtpResource: verifyOtpResource ?? this.verifyOtpResource,
      resetPasswordResource:
          resetPasswordResource ?? this.resetPasswordResource,
    );
  }

  @override
  List<Object?> get props => [
    step,
    email,
    newPassword,
    confirmPassword,
    resendCooldown,
    sendCodeResource,
    verifyOtpResource,
    resetPasswordResource,
  ];
}
