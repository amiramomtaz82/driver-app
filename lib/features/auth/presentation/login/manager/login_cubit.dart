import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/features/auth/domain/models/login_response_model.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/go_routes/routes_names.dart';
import 'package:driver_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base/base_cubit.dart';
import 'login_intents.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, UiEvent> {
  final AuthRepo _authRepo;

  LoginCubit(this._authRepo) : super(const LoginState());

  void onIntent(LoginIntent intent) {
    switch (intent) {
      case EmailChanged():
        emit(state.copyWith(email: intent.value));
      case PasswordChanged():
        emit(state.copyWith(password: intent.value));
      case RememberMeToggled():
        emit(state.copyWith(rememberMe: !state.rememberMe));
      case TogglePasswordVisibility():
        emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
      case LoginSubmitted():
        _login();
      case ForgotPasswordTapped():
        emitEvent(NavigateEvent(AppRoutes.forgotPassword));
    }
  }

  Future<void> _login() async {
    emit(state.copyWith(loginResource: const Resource.loading()));

    final response = await _authRepo.login(
      email: state.email,
      password: state.password,
      rememberMe: state.rememberMe,
    );

    switch (response) {
      case SuccessResponse<LoginResponseModel> s:
        emit(state.copyWith(loginResource: Resource.success(s.data)));
        emitEvent(const NavigateReplacementEvent(AppRoutes.home));
      case ErrorResponse<LoginResponseModel> e:
        emit(state.copyWith(
          loginResource: Resource.error(e.errMessage),
        ));
        emitEvent(ShowSnackBarEvent(
          message: e.errMessage,
          isError: true,
        ));
    }
  }
}
