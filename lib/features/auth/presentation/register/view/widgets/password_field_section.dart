import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/validation/validation.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../manager/register_cubit.dart';
import '../../manager/register_intents.dart';
import '../../manager/register_state.dart';

class PasswordFieldsSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordFieldsSection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
      previous.isPasswordHidden != current.isPasswordHidden ||
          previous.isConfirmPasswordHidden != current.isConfirmPasswordHidden,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: passwordController,
                obscureText: state.isPasswordHidden,
                decoration: InputDecoration(
                  labelText: LocaleKeys.auth_password_label.tr(),
                  hintText: LocaleKeys.auth_password_hint.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () => context
                        .read<RegisterCubit>()
                        .onIntent(const TogglePasswordVisibilityIntent()),
                  ),
                ),
                validator: Validators.validatePassword,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: confirmPasswordController,
                obscureText: state.isConfirmPasswordHidden,
                decoration: InputDecoration(
                  labelText: LocaleKeys.apply_confirm_password_label.tr(),
                  hintText: LocaleKeys.apply_confirm_password_hint.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isConfirmPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () => context
                        .read<RegisterCubit>()
                        .onIntent(const ToggleConfirmPasswordVisibilityIntent()),
                  ),
                ),
                validator: (v) => Validators.validateConfirmPassword(
                  v,
                  passwordController.text,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}