import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/mixins/ui_event_handler_mixin.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/validation/validation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../manager/change_password_cubit.dart';
import '../manager/change_password_intents.dart';
import '../manager/change_password_state.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView>
    with UiEventMixin<ChangePasswordView, ChangePasswordState, UiEvent> {
  final _formKey = GlobalKey<FormState>();

  @override
  ChangePasswordCubit get cubit => _cubit;
  final ChangePasswordCubit _cubit = GetIt.I<ChangePasswordCubit>();

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
            LocaleKeys.reset_password_title.tr(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          titleSpacing: 0,
          leading: const BackButton(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocSelector<ChangePasswordCubit, ChangePasswordState, String?>(
                  selector: (s) => s.currentPasswordError,
                  builder: (context, currentPasswordError) {
                    return TextFormField(
                      onChanged: (v) =>
                          _cubit.onIntent(CurrentPasswordChanged(v)),
                      validator: Validators.validatePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: LocaleKeys
                            .reset_password_current_password_label
                            .tr(),
                        hintText: LocaleKeys
                            .reset_password_current_password_hint
                            .tr(),
                        errorText: currentPasswordError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (v) => _cubit.onIntent(NewPasswordChanged(v)),
                  validator: Validators.validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText:
                        LocaleKeys.reset_password_new_password_label.tr(),
                    hintText:
                        LocaleKeys.reset_password_new_password_hint.tr(),
                  ),
                ),
                const SizedBox(height: 16),
                BlocSelector<ChangePasswordCubit, ChangePasswordState, String>(
                  selector: (s) => s.newPassword,
                  builder: (context, newPassword) {
                    return TextFormField(
                      onChanged: (v) =>
                          _cubit.onIntent(ConfirmPasswordChanged(v)),
                      validator: (v) =>
                          Validators.validateConfirmPassword(v, newPassword),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: LocaleKeys
                            .reset_password_confirm_password_label
                            .tr(),
                        hintText: LocaleKeys
                            .reset_password_confirm_password_hint
                            .tr(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                BlocSelector<ChangePasswordCubit, ChangePasswordState,
                    ({bool isFormValid, ApiStatus status})>(
                  selector: (s) => (
                    isFormValid: s.isFormValid,
                    status: s.changePasswordResource.status,
                  ),
                  builder: (context, data) {
                    return ElevatedButton(
                      onPressed: data.isFormValid &&
                              data.status != ApiStatus.loading
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _cubit.onIntent(
                                  const ChangePasswordSubmitted(),
                                );
                              }
                            }
                          : null,
                      child: data.status == ApiStatus.loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(LocaleKeys.common_update.tr()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
