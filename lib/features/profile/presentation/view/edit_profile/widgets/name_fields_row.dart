import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/validation/validation.dart';
import '../../../../../../generated/locale_keys.g.dart';

class NameFieldsRow extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final FormFieldValidator<String>? firstNameValidator;
  final FormFieldValidator<String>? lastNameValidator;

  const NameFieldsRow({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    this.firstNameValidator,
    this.lastNameValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: firstNameController,
            onChanged: onFirstNameChanged,
            validator: firstNameValidator ?? Validators.validateName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: LocaleKeys.apply_first_name_label.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: lastNameController,
            onChanged: onLastNameChanged,
            validator: lastNameValidator ?? Validators.validateName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: LocaleKeys.apply_second_name_label.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}