import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/mixins/ui_event_handler_mixin.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/validation/validation.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_intents.dart';
import 'package:driver_app/features/auth/presentation/login/manager/login_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../generated/locale_keys.g.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with UiEventMixin<LoginView, LoginState, UiEvent> {
  final _formKey = GlobalKey<FormState>();

  @override
  LoginCubit get cubit => _cubit;
  final LoginCubit _cubit = GetIt.I<LoginCubit>();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.auth_login_title.tr(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          titleSpacing: 0,
          leading: const BackButton(),
        ),
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      key: const Key('emailField'),
                      initialValue: state.email,
                      onChanged: (v) =>
                          _cubit.onIntent(EmailChanged(v)),
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.auth_email_label.tr(),
                        hintText: LocaleKeys.auth_email_hint.tr(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('passwordField'),
                      initialValue: state.password,
                      onChanged: (v) =>
                          _cubit.onIntent(PasswordChanged(v)),
                      validator: Validators.validatePassword,
                      obscureText: !state.isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.auth_password_label.tr(),
                        hintText: LocaleKeys.auth_password_hint.tr(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => _cubit
                              .onIntent(const TogglePasswordVisibility()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          key: const Key('rememberMeCheckbox'),
                          value: state.rememberMe,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (_) =>
                              _cubit.onIntent(const RememberMeToggled()),
                        ),
                        Text(
                          LocaleKeys.auth_remember_me.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        TextButton(
                          key: const Key('forgotPasswordBtn'),
                          onPressed: () =>
                              _cubit.onIntent(const ForgotPasswordTapped()),
                          child: Text(
                            LocaleKeys.auth_forgot_password.tr(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      key: const Key('continueBtn'),
                      onPressed: state.isFormValid &&
                              state.loginResource.status != ApiStatus.loading
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _cubit.onIntent(const LoginSubmitted());
                              }
                            }
                          : null,
                      child: state.loginResource.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(LocaleKeys.common_continue.tr()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
