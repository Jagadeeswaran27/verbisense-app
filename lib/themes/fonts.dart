import 'package:flutter/material.dart';

import 'package:verbisense/themes/colors.dart';

class ThemeFonts {
  ThemeFonts._();

  static const String poppins = 'Poppins';
  static final ThemeData baseTheme = ThemeData.light();
  static final TextTheme textTheme = baseTheme.textTheme;

  static TextTheme buildLightTextTheme(BuildContext context) {
    return baseTheme.textTheme
        .copyWith(
          // heading 2
          headlineLarge: baseTheme.textTheme.headlineLarge!.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: ThemeColors.white,
          ),
          // heading 3
          headlineMedium: baseTheme.textTheme.headlineMedium!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: ThemeColors.black,
          ),
          // heading 4
          headlineSmall: baseTheme.textTheme.headlineSmall!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ThemeColors.black,
          ),
          // heading 5
          titleLarge: baseTheme.textTheme.titleLarge!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeColors.black,
          ),
          // heading 6
          titleMedium: baseTheme.textTheme.titleMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeColors.black,
          ),
          titleSmall: baseTheme.textTheme.titleSmall!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ThemeColors.white,
          ),
          bodyLarge: baseTheme.textTheme.bodyLarge!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: ThemeColors.black,
          ),
          // body copy
          bodyMedium: baseTheme.textTheme.bodyMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ThemeColors.black,
          ),
          // body text 2
          bodySmall: baseTheme.textTheme.bodySmall!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ThemeColors.white,
          ),
          displayMedium: baseTheme.textTheme.displayMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ThemeColors.black,
          ),
          displaySmall: baseTheme.textTheme.displaySmall!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: ThemeColors.black,
          ),
        )
        .apply(
          fontFamily: poppins,
        );
  }
}

extension ThemeExtension on TextTheme {
  TextStyle get headlineLargeBlack =>
      headlineLarge!.copyWith(color: ThemeColors.black);
  TextStyle get headlineMediumWhite =>
      headlineMedium!.copyWith(color: ThemeColors.white);
  TextStyle get headlineSmallWhite =>
      headlineSmall!.copyWith(color: ThemeColors.white);
  TextStyle get headlineSmallGray =>
      headlineSmall!.copyWith(color: ThemeColors.gray200);
  TextStyle get headlineSmallRegular =>
      headlineSmall!.copyWith(fontWeight: FontWeight.w400);
  TextStyle get headlineSmallRegularGrey => headlineSmall!
      .copyWith(fontWeight: FontWeight.w400, color: ThemeColors.gray200);
  TextStyle get titleLargeWhite =>
      titleLarge!.copyWith(color: ThemeColors.white);
  TextStyle get bodyMediumPrimary =>
      bodyMedium!.copyWith(color: ThemeColors.primary);
  TextStyle get bodyMediumWhite =>
      bodyMedium!.copyWith(color: ThemeColors.white);
  TextStyle get bodyMediumBoldWhite => bodyMedium!
      .copyWith(fontWeight: FontWeight.w700, color: ThemeColors.white);
  TextStyle get bodySmallGray =>
      bodySmall!.copyWith(color: ThemeColors.gray200);
  TextStyle get bodySmallBlack => bodySmall!.copyWith(color: ThemeColors.black);
  TextStyle get displayMediumGray =>
      displayMedium!.copyWith(color: ThemeColors.gray200);
  TextStyle get displayMediumStrongWhite => displayMedium!
      .copyWith(fontWeight: FontWeight.w500, color: ThemeColors.white);
  TextStyle get displaySmallWhite =>
      displaySmall!.copyWith(color: ThemeColors.white);
  TextStyle get bodyLargeLight =>
      bodyLarge!.copyWith(fontWeight: FontWeight.w400);
  TextStyle get errorBodyMedium =>
      bodyMedium!.copyWith(color: ThemeColors.errorColor);
}
