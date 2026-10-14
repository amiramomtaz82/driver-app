import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../generated/locale_keys.g.dart';

class NameFieldsRow extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;

  const NameFieldsRow({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: firstNameController,
            onChanged: onFirstNameChanged,
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