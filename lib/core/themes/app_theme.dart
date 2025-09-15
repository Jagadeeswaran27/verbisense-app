import 'package:flutter/material.dart';

import 'package:verbisense/core/themes/fonts.dart';

class AppTheme {
  AppTheme._();

  static get lightTheme => ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    fontFamily: Fonts.poppins,
  );
}
