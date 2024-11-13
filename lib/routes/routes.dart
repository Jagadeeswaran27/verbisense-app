import 'package:flutter/material.dart';
import 'package:verbisense/screens/home_screen.dart';
import 'package:verbisense/wrappers/auth_wrapper.dart';

class Routes {
  const Routes._();

  static const String wrapper = '/wrapper';
  static const String home = '/';

  static Map<String, WidgetBuilder> get buildRoutes {
    return {
      home: (context) => const HomeScreen(),
      wrapper: (context) => const AuthWrapper(),
    };
  }

  static String get initialRoute => wrapper;
  static Widget get initialScreem => const AuthWrapper();
}
