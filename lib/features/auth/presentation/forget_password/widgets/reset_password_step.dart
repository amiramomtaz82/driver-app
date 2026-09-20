import 'package:driver_app/core/validation/validation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../manager/forget_password_cubit.dart';
import '../manager/forget_password_intents.dart';
import '../manager/forget_password_state.dart';
import 'auth_header_text.dart';
import 'auth_submit_button.dart';

class ResetPasswordStep extends StatefulWidget {
  const ResetPasswordStep({super.key});

  @override
  State<ResetPasswordStep> createState() => _ResetPasswordStepState();
}

class _ResetPasswordStepState extends State<ResetPasswordStep>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  void _onConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgetPasswordCubit>().onIntent(
        const ResetPasswordSubmitted(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cubit = context.read<ForgetPasswordCubit>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        spacing: 24,
        children: [
          AuthHeaderText(
            title: LocaleKeys.reset_password_title.tr(),
            subtitle: LocaleKeys.forget_password_reset_subtitle.tr(),
          ),
          Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                TextFormField(
                  key: const Key('newPasswordField'),
                  initialValue: cubit.state.newPassword,
                  onChanged: (v) => cubit.onIntent(NewPasswordChanged(v)),
                  validator: Validators.validatePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reset_password_new_password_label
                        .tr(),
                    hintText: LocaleKeys.reset_password_new_password_hint.tr(),
                  ),
                ),
                TextFormField(
                  key: const Key('confirmPasswordField'),
                  initialValue: cubit.state.confirmPassword,
                  onChanged: (v) => cubit.onIntent(ConfirmPasswordChanged(v)),
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    cubit.state.newPassword,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.reset_password_confirm_password_label
                        .tr(),
                    hintText: LocaleKeys.reset_password_confirm_password_hint
                        .tr(),
                  ),
                ),
              ],
            ),
          ),
          BlocSelector<ForgetPasswordCubit, ForgetPasswordState, (bool, bool)>(
            selector: (state) => (
              state.isResetFormValid,
              state.resetPasswordResource.isLoading,
            ),
            builder: (context, selected) {
              final (isFormValid, isLoading) = selected;
              return AuthSubmitButton(
                key: const Key('resetPasswordBtn'),
                label: LocaleKeys.forget_password_confirm.tr(),
                isLoading: isLoading,
                onPressed: isFormValid ? _onConfirm : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
