import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../generated/locale_keys.g.dart';

class VehicleNumberField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const VehicleNumberField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: LocaleKeys.apply_vehicle_number_label.tr(),
        hintText: 'UP16DL0007',
        border: const OutlineInputBorder(),
      ),
    );
  }
}