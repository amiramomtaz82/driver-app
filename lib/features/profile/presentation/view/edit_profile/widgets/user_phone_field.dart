import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../generated/locale_keys.g.dart';

class UserPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const UserPhoneField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: LocaleKeys.apply_phone_label.tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}