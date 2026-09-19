import 'dart:async';

import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/auth/domain/models/message_response_model.dart';
import 'package:driver_app/features/auth/domain/models/verify_otp_response_model.dart';
import 'package:driver_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'forget_password_intents.dart';
import 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, UiEvent> {
  final AuthRepo _authRepo;

  ForgetPasswordCubit(this._authRepo) : super(const ForgetPasswordState());

  static const int resendCooldownSeconds = 30;

  Timer? _resendTimer;

  void onIntent(ForgetPasswordIntent intent) {
    switch (intent) {
      case EmailChanged():
        emit(state.copyWith(email: intent.value.trim()));
      case SendCodeSubmitted():
        _sendCode();
      case ResendCodeTapped():
        _sendCode(isResend: true);
      case OtpChanged():
        _clearOtpError();
      case OtpCompleted():
        _verifyOtp(intent.code);
      case NewPasswordChanged():
        emit(state.copyWith(newPassword: intent.value));
      case ConfirmPasswordChanged():
        emit(state.copyWith(confirmPassword: intent.value));
      case ResetPasswordSubmitted():
        _resetPassword();
      case BackPressed():
        _goBack();
    }
  }

  Future<void> _sendCode({bool isResend = false}) async {
    if (state.sendCodeResource.isLoading) return;
    if (isResend && state.resendCooldown > 0) return;

    emit(
      state.copyWith(
        sendCodeResource: const Resource.loading(),
        verifyOtpResource: const Resource.initial(),
      ),
    );

    final response = await _authRepo.forgetPassword(email: state.email);

    switch (response) {
      case SuccessResponse<MessageResponseModel> s:
        emit(
          state.copyWith(
            sendCodeResource: Resource.success(s.data),
            resendCooldown: resendCooldownSeconds,
            step: isResend ? null : ForgetPasswordStep.otp,
          ),
        );
        if (isResend) {
          emitEvent(
            const ShowSnackBarEvent(message: LocaleKeys.forget_password_code_sent),
          );
        }
        _startResendCooldown();
      case ErrorResponse<MessageResponseModel> e:
        emit(state.copyWith(sendCodeResource: Resource.error(e.errMessage)));
        emitEvent(ShowSnackBarEvent(message: e.errMessage, isError: true));
    }
  }

  Future<void> _verifyOtp(String code) async {
    if (state.verifyOtpResource.isLoading) return;

    emit(state.copyWith(verifyOtpResource: const Resource.loading()));

    final response = await _authRepo.verifyOtp(
      email: state.email,
      otpCode: code,
    );

    switch (response) {
      case SuccessResponse<ResetTokenModel> s:
        emit(
          state.copyWith(
            verifyOtpResource: Resource.success(s.data),
            step: ForgetPasswordStep.resetPassword,
          ),
        );
      case ErrorResponse<ResetTokenModel> e:
        // The OTP step shows this one inline, so no snackbar event.
        // The backend answers a wrong code with a technical 500, so any
        // server answer means the code was rejected.
        final message = e.statusCode != null
            ? LocaleKeys.forget_password_invalid_code
            : e.errMessage;
        emit(state.copyWith(verifyOtpResource: Resource.error(message)));
    }
  }

  void _clearOtpError() {
    if (!state.verifyOtpResource.isError) return;
    emit(state.copyWith(verifyOtpResource: const Resource.initial()));
  }

  Future<void> _resetPassword() async {
    if (state.resetPasswordResource.isLoading) return;

    final resetToken = state.resetToken;

    if (resetToken == null || resetToken.isExpired(DateTime.now())) {
      emit(
        state.copyWith(
          verifyOtpResource: const Resource.error(
            LocaleKeys.forget_password_reset_session_expired,
          ),
          step: ForgetPasswordStep.otp,
        ),
      );
      return;
    }

    emit(state.copyWith(resetPasswordResource: const Resource.loading()));

    final response = await _authRepo.resetPassword(
      resetToken: resetToken.resetToken,
      newPassword: state.newPassword,
      confirmNewPassword: state.confirmPassword,
    );

    switch (response) {
      case SuccessResponse<MessageResponseModel> s:
        emit(state.copyWith(resetPasswordResource: Resource.success(s.data)));
        emitEvent(const NavigateReplacementEvent(AppRoutes.login));
      case ErrorResponse<MessageResponseModel> e:
        emit(
          state.copyWith(resetPasswordResource: Resource.error(e.errMessage)),
        );
        emitEvent(ShowSnackBarEvent(message: e.errMessage, isError: true));
    }
  }

  void _goBack() {
    if (state.step == ForgetPasswordStep.email) {
      emitEvent(const PopEvent());
      return;
    }
    emit(
      state.copyWith(step: ForgetPasswordStep.values[state.step.index - 1]),
    );
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final secondsLeft = state.resendCooldown - 1;
      emit(state.copyWith(resendCooldown: secondsLeft));
      if (secondsLeft <= 0) timer.cancel();
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }
}
