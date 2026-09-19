import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/mixins/ui_event_handler_mixin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../manager/forget_password_cubit.dart';
import '../manager/forget_password_intents.dart';
import '../manager/forget_password_state.dart';
import '../widgets/email_step.dart';
import '../widgets/otp_verification_step.dart';
import '../widgets/reset_password_step.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView>
    with UiEventMixin<ForgetPasswordView, ForgetPasswordState, UiEvent> {
  final _pageController = PageController();

  @override
  ForgetPasswordCubit get cubit => _cubit;
  final ForgetPasswordCubit _cubit = GetIt.I<ForgetPasswordCubit>();

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _goToStep(ForgetPasswordStep step) {
    _pageController.animateToPage(
      step.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listenWhen: (previous, current) => previous.step != current.step,
        listener: (context, state) => _goToStep(state.step),
        buildWhen: (previous, current) => previous.step != current.step,
        builder: (context, state) => PopScope(
          canPop: state.step == ForgetPasswordStep.email,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _cubit.onIntent(const BackPressed());
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                LocaleKeys.forget_password_title.tr(),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              centerTitle: false,
              titleSpacing: 0,
              leading: BackButton(
                onPressed: () => _cubit.onIntent(const BackPressed()),
              ),
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                EmailStep(),
                OtpVerificationStep(),
                ResetPasswordStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
