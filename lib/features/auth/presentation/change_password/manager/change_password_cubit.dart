import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/features/auth/domain/entities/auth_message_entity.dart';
import 'package:driver_app/features/auth/domain/use_cases/change_password_use_case.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import 'change_password_intents.dart';
import 'change_password_state.dart';

@injectable
class ChangePasswordCubit extends BaseCubit<ChangePasswordState, UiEvent> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit(this._changePasswordUseCase)
      : super(const ChangePasswordState());

  void onIntent(ChangePasswordIntent intent) {
    switch (intent) {
      case CurrentPasswordChanged():
        emit(
          state.copyWith(
            currentPassword: intent.value,
            clearCurrentPasswordError: true,
          ),
        );
      case NewPasswordChanged():
        emit(state.copyWith(newPassword: intent.value));
      case ConfirmPasswordChanged():
        emit(state.copyWith(confirmPassword: intent.value));
      case ChangePasswordSubmitted():
        _changePassword();
    }
  }

  Future<void> _changePassword() async {
    if (state.changePasswordResource.isLoading) return;

    emit(state.copyWith(changePasswordResource: const Resource.loading()));

    final response = await _changePasswordUseCase(
      currentPassword: state.currentPassword,
      newPassword: state.newPassword,
      confirmNewPassword: state.confirmPassword,
    );

    switch (response) {
      case SuccessResponse<AuthMessageEntity> s:
        emit(
          state.copyWith(
            changePasswordResource: Resource.success(s.data),
            clearCurrentPasswordError: true,
          ),
        );
        emitEvent(
          ShowSnackBarEvent(
            message: s.data.message ?? 'reset_password.title'.tr(),
          ),
        );
        emitEvent(const PopEvent());
      case ErrorResponse<AuthMessageEntity> e:
        final message = e.errMessage.tr();
        emit(
          state.copyWith(
            changePasswordResource: Resource.error(message),
            currentPasswordError: message,
          ),
        );
        emitEvent(ShowSnackBarEvent(message: message, isError: true));
    }
  }
}
