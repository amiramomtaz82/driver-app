import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../generated/locale_keys.g.dart';

class UserEmailField extends StatelessWidget {
  final String email;

  const UserEmailField({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: email,
      readOnly: true,
      decoration: InputDecoration(
        labelText: LocaleKeys.auth_email_label.tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}