import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/app_theme/app_colors.dart';
import '../../../../../../generated/locale_keys.g.dart';

class UpdateVehicleButton extends StatelessWidget {
  final bool isValid;
  final bool isLoading;
  final VoidCallback onPressed;

  const UpdateVehicleButton({
    super.key,
    required this.isValid,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isValid ? AppColors.pink : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: isValid && !isLoading ? onPressed : null,
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : Text(LocaleKeys.common_update.tr()),
      ),
    );
  }
}