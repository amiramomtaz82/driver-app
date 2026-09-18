import 'package:flutter/material.dart';

import 'custom_colors.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  CustomColors get customColors =>
      Theme.of(this).extension<CustomColors>() ?? CustomColors.light;
}