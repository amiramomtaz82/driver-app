import 'package:flutter/material.dart';
import '../../../../../../core/app_theme/context_extension.dart';

class ProfileVersionText extends StatelessWidget {
  const ProfileVersionText({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Center(
      child: Text(
        'v 6.3.0 - (446)',
        style: TextStyle(color: colors.grey, fontSize: 12),
      ),
    );
  }
}