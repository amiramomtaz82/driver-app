import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AuthHeaderText extends StatelessWidget {
  const AuthHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(title.tr(), style: textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(
          subtitle.tr(),
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
