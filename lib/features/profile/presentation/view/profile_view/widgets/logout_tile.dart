import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/app_theme/context_extension.dart';
import '../../../../../../generated/locale_keys.g.dart';

class LogoutTile extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final colors = context.customColors;
    return ListTile(
      leading: const Icon(Icons.logout_outlined,size: 20),
      title: Text(LocaleKeys.common_logout.tr(),style:
      textTheme.bodySmall?.copyWith(color: colors.black),),
      trailing: const Icon(Icons.exit_to_app_outlined,size: 20,),
      onTap: onTap,
    );
  }
}