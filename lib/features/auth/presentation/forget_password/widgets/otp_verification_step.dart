import 'package:driver_app/core/app_theme/context_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../manager/forget_password_cubit.dart';
import '../manager/forget_password_intents.dart';
import '../manager/forget_password_state.dart';
import 'auth_header_text.dart';
import 'otp_holder.dart';

class OtpVerificationStep extends StatefulWidget {
  const OtpVerificationStep({super.key});

  @override
  State<OtpVerificationStep> createState() => _OtpVerificationStepState();
}

class _OtpVerificationStepState extends State<OtpVerificationStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cubit = context.read<ForgetPasswordCubit>();
    final textTheme = context.theme.textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const AuthHeaderText(
            title: LocaleKeys.forget_password_otp_title,
            subtitle: LocaleKeys.forget_password_otp_subtitle,
          ),
          const SizedBox(height: 24),
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            buildWhen: (previous, current) =>
                previous.otpErrorMessage != current.otpErrorMessage ||
                previous.verifyOtpResource.isLoading !=
                    current.verifyOtpResource.isLoading,
            builder: (context, state) => Column(
              children: [
                OtpHolder(
                  errorText: state.otpErrorMessage?.tr(),
                  onChanged: (_) => cubit.onIntent(const OtpChanged()),
                  onCompleted: (code) => cubit.onIntent(OtpCompleted(code)),
                ),
                if (state.verifyOtpResource.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                LocaleKeys.forget_password_didnt_receive_code.tr(),
                style: textTheme.bodyMedium,
              ),
              BlocSelector<
                ForgetPasswordCubit,
                ForgetPasswordState,
                (bool, int)
              >(
                selector: (state) => (state.canResend, state.resendCooldown),
                builder: (context, selected) {
                  final (canResend, cooldown) = selected;
                  final color = canResend
                      ? context.customColors.primary
                      : context.customColors.grey;
                  final label = LocaleKeys.forget_password_resend.tr();
                  return TextButton(
                    key: const Key('resendCodeBtn'),
                    onPressed: canResend
                        ? () => cubit.onIntent(const ResendCodeTapped())
                        : null,
                    child: Text(
                      cooldown > 0 ? '$label ($cooldown)' : label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: color,
                        decoration: TextDecoration.underline,
                        decorationColor: color,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
