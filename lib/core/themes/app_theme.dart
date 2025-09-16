import 'package:flutter/material.dart';

import 'package:verbisense/core/themes/colors.dart';
import 'package:verbisense/core/themes/fonts.dart';

class AppTheme {
  AppTheme._();

  static AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(elevation: 0);
  }

  static ThemeData buildLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      fontFamily: ThemeFonts.poppins,
      appBarTheme: _buildAppBarTheme(),
      textTheme: ThemeFonts.buildLightTextTheme(context),
      scaffoldBackgroundColor: ThemeColors.white,
      primaryColor: ThemeColors.primary,
      colorScheme: ColorScheme.light(
        primary: ThemeColors.primary,
        secondary: ThemeColors.primary,
      ),
    );
  }
}
