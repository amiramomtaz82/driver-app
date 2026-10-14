import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/app_theme/context_extension.dart';
import '../../../../../../generated/locale_keys.g.dart';

class SettingsLanguageTile extends StatelessWidget {
  const SettingsLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final isArabic = context.locale.languageCode == 'ar';
    final textTheme = context.theme.textTheme;

    return ListTile(
      leading: const Icon(Icons.translate_outlined,size: 20),
      title: Text(LocaleKeys.profile_language.tr(),style:
      textTheme.bodySmall?.copyWith(color: colors.black),),
      trailing: Text(
        isArabic ? 'العربية' : 'English',
        style: TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        final newLocale = isArabic ? const Locale('en') : const Locale('ar');
        context.setLocale(newLocale);
      },
    );
  }
}