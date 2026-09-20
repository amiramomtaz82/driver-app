import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/entities/reset_token_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:driver_app/features/auth/domain/use_cases/verify_otp_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../generated/locale_keys.g.dart';
import 'forget_password_intents.dart';
import 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, UiEvent> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgetPasswordCubit(
    this._forgetPasswordUseCase,
    this._verifyOtpUseCase,
    this._resetPasswordUseCase,
  ) : super(const ForgetPasswordState());

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

    final response = await _forgetPasswordUseCase(email: state.email);

    switch (response) {
      case SuccessResponse<AuthMessageEntity> s:
        emit(
          state.copyWith(
            sendCodeResource: Resource.success(s.data),
            resendCooldown: resendCooldownSeconds,
            step: isResend ? null : ForgetPasswordStep.otp,
          ),
        );
        if (isResend) {
          emitEvent(
            ShowSnackBarEvent(
              message: LocaleKeys.forget_password_code_sent.tr(),
            ),
          );
        }
        _startResendCooldown();
      case ErrorResponse<AuthMessageEntity> e:
        emit(state.copyWith(sendCodeResource: Resource.error(e.errMessage.tr())));
        emitEvent(ShowSnackBarEvent(message: e.errMessage.tr(), isError: true));
    }
  }

  Future<void> _verifyOtp(String code) async {
    if (state.verifyOtpResource.isLoading) return;

    emit(state.copyWith(verifyOtpResource: const Resource.loading()));

    final response = await _verifyOtpUseCase(
      email: state.email,
      otpCode: code,
    );

    switch (response) {
      case SuccessResponse<ResetToken> s:
        emit(
          state.copyWith(
            verifyOtpResource: Resource.success(s.data),
            step: ForgetPasswordStep.resetPassword,
          ),
        );
      case ErrorResponse<ResetToken> e:
        // The OTP step shows this one inline, so no snackbar event.
        // The backend answers a wrong code with a technical 500, so any
        // server answer means the code was rejected.
        final message = e.statusCode != null
            ? LocaleKeys.forget_password_invalid_code
            : e.errMessage;
        emit(state.copyWith(verifyOtpResource: Resource.error(message.tr())));
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
          verifyOtpResource: Resource.error(
            LocaleKeys.forget_password_reset_session_expired.tr(),
          ),
          step: ForgetPasswordStep.otp,
        ),
      );
      return;
    }

    emit(state.copyWith(resetPasswordResource: const Resource.loading()));

    final response = await _resetPasswordUseCase(
      resetToken: resetToken.token,
      newPassword: state.newPassword,
      confirmNewPassword: state.confirmPassword,
    );

    switch (response) {
      case SuccessResponse<AuthMessageEntity> s:
        emit(state.copyWith(resetPasswordResource: Resource.success(s.data)));
        emitEvent(const NavigateReplacementEvent(AppRoutes.login));
      case ErrorResponse<AuthMessageEntity> e:
        emit(
          state.copyWith(
            resetPasswordResource: Resource.error(e.errMessage.tr()),
          ),
        );
        emitEvent(ShowSnackBarEvent(message: e.errMessage.tr(), isError: true));
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
