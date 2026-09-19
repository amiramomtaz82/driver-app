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

class EmailStep extends StatefulWidget {
  const EmailStep({super.key});

  @override
  State<EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<EmailStep>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  void _onConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgetPasswordCubit>().onIntent(const SendCodeSubmitted());
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
          const AuthHeaderText(
            title: LocaleKeys.forget_password_email_title,
            subtitle: LocaleKeys.forget_password_email_subtitle,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              key: const Key('emailField'),
              initialValue: cubit.state.email,
              onChanged: (v) => cubit.onIntent(EmailChanged(v)),
              validator: Validators.validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: LocaleKeys.auth_email_label.tr(),
                hintText: LocaleKeys.auth_email_hint.tr(),
              ),
            ),
          ),
          BlocSelector<ForgetPasswordCubit, ForgetPasswordState, (bool, bool)>(
            selector: (state) =>
                (state.isEmailValid, state.sendCodeResource.isLoading),
            builder: (context, selected) {
              final (isEmailValid, isLoading) = selected;
              return AuthSubmitButton(
                key: const Key('sendCodeBtn'),
                label: LocaleKeys.forget_password_confirm,
                isLoading: isLoading,
                onPressed: isEmailValid ? _onConfirm : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
