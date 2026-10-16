import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/app_theme/context_extension.dart';
import '../../../../../../core/enums/app_language.dart';
import '../../../../../../generated/locale_keys.g.dart';

class SettingsLanguageTile extends StatelessWidget {
  const SettingsLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final currentLanguage = AppLanguage.fromLocale(context.locale);
    final textTheme = context.theme.textTheme;

    return ListTile(
      leading: const Icon(Icons.translate_outlined, size: 20),
      title: Text(
        LocaleKeys.profile_language.tr(),
        style: textTheme.bodySmall?.copyWith(color: colors.black),
      ),
      trailing: Text(
        currentLanguage.displayName,
        style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        context.setLocale(currentLanguage.nextLanguage.locale);
      },
    );
  }
}