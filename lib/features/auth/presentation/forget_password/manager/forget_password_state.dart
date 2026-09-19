import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/models/message_response_model.dart';
import 'package:driver_app/features/auth/domain/models/verify_otp_response_model.dart';
import 'package:equatable/equatable.dart';

enum ForgetPasswordStep { email, otp, resetPassword }

class ForgetPasswordState extends Equatable {
  final ForgetPasswordStep step;
  final String email;
  final String newPassword;
  final String confirmPassword;
  final int resendCooldown;
  final Resource<MessageResponseModel> sendCodeResource;
  final Resource<ResetTokenModel> verifyOtpResource;
  final Resource<MessageResponseModel> resetPasswordResource;

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
  ResetTokenModel? get resetToken => verifyOtpResource.data;

  /// The inline error under the OTP boxes — only while the verify step failed.
  String? get otpErrorMessage =>
      verifyOtpResource.isError ? verifyOtpResource.errorMessage : null;

  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    String? email,
    String? newPassword,
    String? confirmPassword,
    int? resendCooldown,
    Resource<MessageResponseModel>? sendCodeResource,
    Resource<ResetTokenModel>? verifyOtpResource,
    Resource<MessageResponseModel>? resetPasswordResource,
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
