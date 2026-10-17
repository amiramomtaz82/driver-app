import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/app_theme/app_colors.dart';
import '../../../../../../generated/locale_keys.g.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.common_gender.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 16),
          Radio<String>(
            value: 'Female',
            groupValue: selectedGender,
            activeColor: AppColors.pink,
            onChanged: (v) => onGenderChanged(v!),
          ),
          Text(LocaleKeys.common_gender_female.tr()),
          const SizedBox(width: 8),
          Radio<String>(
            value: 'Male',
            groupValue: selectedGender,
            activeColor: AppColors.pink,
            onChanged: (v) => onGenderChanged(v!),
          ),
          Text(LocaleKeys.common_gender_male.tr()),
        ],
      ),
    );
  }
}