import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:verbisense/features/auth/presentation/screens/login_screen.dart';
import 'package:verbisense/features/auth/presentation/screens/signup_screen.dart';

enum AppRoutes {
  login,
  signup,
}

extension AppRoutesExtension on AppRoutes {
  static const Map<AppRoutes, String> _paths = {
    AppRoutes.signup: '/signup',
    AppRoutes.login: '/login',
  };

  static const Map<AppRoutes, String> _names = {
    AppRoutes.signup: 'signup',
    AppRoutes.login: 'login',
  };

  static const Map<AppRoutes, Widget Function()> _builders = {
    AppRoutes.login: LoginScreen.new,
    AppRoutes.signup: SignupScreen.new,
  };

  String get path => _paths[this]!;
  String get name => _names[this]!;

  GoRoute get route {
    return GoRoute(
      name: name,
      path: path,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: _builders[this]!(),
        );
      },
    );
  }
}
