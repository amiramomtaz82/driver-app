import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../manager/register_cubit.dart';
import '../../manager/register_state.dart';

class RegisterSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
      previous.registerResource.isLoading != current.registerResource.isLoading,
      builder: (context, state) {
        final isLoading = state.registerResource.isLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : Text(LocaleKeys.common_continue.tr()),
          ),
        );
      },
    );
  }
}