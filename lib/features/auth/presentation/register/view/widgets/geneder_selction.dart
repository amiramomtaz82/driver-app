import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/app_theme/app_colors.dart';
import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../generated/locale_keys.g.dart';
import '../../manager/register_cubit.dart';
import '../../manager/register_intents.dart';
import '../../manager/register_state.dart';

class GenderSelectorSection extends StatelessWidget {
  const GenderSelectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.gender != current.gender,
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return Row(
          children: [
            Text(
              LocaleKeys.common_gender.tr(),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(width: 16),
            Radio<String>(
              value: GenderConstants.female,
              groupValue: state.gender,
              activeColor: AppColors.pink,
              onChanged: (val) {
                if (val != null) cubit.onIntent(SelectGenderIntent(val));
              },
            ),
            Text(LocaleKeys.common_gender_female.tr()),
            const SizedBox(width: 12),
            Radio<String>(
              value: GenderConstants.male,
              groupValue: state.gender,
              activeColor: AppColors.pink,
              onChanged: (val) {
                if (val != null) cubit.onIntent(SelectGenderIntent(val));
              },
            ),
            Text(LocaleKeys.common_gender_male.tr()),
          ],
        );
      },
    );
  }
}